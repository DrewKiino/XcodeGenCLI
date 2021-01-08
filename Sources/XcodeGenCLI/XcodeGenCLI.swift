import Foundation
import SwiftShell

internal enum Flag {
  case workspaceDirectory

  var title: String {
    switch self {
    case .workspaceDirectory: return  "--workspace"
    }
  }
  
  var defaultValue: String {
    switch self {
    case .workspaceDirectory: return  "./"
    }
  }
  
  static func parse(_ argument: String) -> (Flag, String)? {
    let arguments = argument.split(separator: "=")
    if let flag = arguments.first {
      switch String(flag) {
      case Flag.workspaceDirectory.title:
        if let value = arguments.last?.toString() {
          return (.workspaceDirectory, value)
        }
      default:
        break
      }
    }
    return nil
  }
}

public final class XcodeGenCLI {
  private let arguments: [Flag: String]

  public init(arguments: [String] = CommandLine.arguments) {
    self.arguments = Dictionary(arguments.compactMap(Flag.parse), uniquingKeysWith: { $1 })
    self.printArguments()
  }
  
  public func start() throws {
    let workDir = fetchArgument(.workspaceDirectory)
    
    /// Change working directory
    main.currentdirectory = workDir
    
    /// Get `.env` file

    let jsonString = run("cat", "\(workDir)/project.json").stdout
    if let data = jsonString.data(using: .utf8) {
      if var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        json.mutateValue("targets") { (targets: inout [String: Any]) in
          targets.mutateValue("Project") { (project: inout [String: Any]) in
            project.mutateValue("scheme") { (scheme: inout [String: Any]) in
              scheme.mutateValue("environmentVariables") { (envVars: inout [String: Any]) in
                /// Merge the `.env` file with this project
                envVars.merge(envFile(), uniquingKeysWith: { $1 })
              }
            }
          }
        }
        let newData =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        if let newJsonString = String(data: newData, encoding: .utf8) {
          run(bash: "echo '\(newJsonString)' > project.json")
        }
      }
    }
  }
  
  private func fetchArgument(_ flag: Flag) -> String {
    self.arguments[flag] ?? ProcessInfo.processInfo.environment[flag.title] ?? flag.defaultValue
  }
  
  private func printArguments() {
    let arguments = self.arguments
      .map { flag, value in "\(flag.title)=\(value)" }
      .joined(separator: ",")
    print("Flags: \(arguments)")
  }
}

private func envFile() -> [String: String] {
  return Dictionary(run(bash: "cat .env").stdout.split(separator: "\n").compactMap { argument -> (String, String)? in
    let split = argument.split(separator: "=")
    if let key = split.first?.toString(), let value = split.last?.toString() {
      return (key, value)
    }
    return nil
  }, uniquingKeysWith: { $1 })
}

private extension Substring {
  func toString() -> String { String(self) }
}

internal struct Project: Codable {
  let targets: [String: Target]
}

internal struct Target: Codable {
  let scheme: Scheme
}

internal struct Scheme: Codable {
  let environmentVariables: [String: String]
}

private extension Dictionary where Key == String, Value == Any {
  mutating func mutateValue<T>(_ key: String, closure: (inout T) -> ()) {
    if var value = self[key] as? T {
      closure(&value)
      self[key] = value
    }
  }
}
