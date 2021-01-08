import Foundation
import SwiftShell

@available(OSX 10.13, *)
public struct XcodeGenCLI {
  private let commands: Commands
  private let arguments: Arguments

  public init?(arguments: [String] = CommandLine.arguments) {
    guard arguments.count > 1, let commands = Commands(arguments) else {
      /// TODO: print help
      print("""
      Commands:

        update-env    update the project's env variables
        
          ex: 'update-env --targets=MyApp'
      
      """)
      return nil
    }
    
    self.commands = commands
    self.arguments = Arguments(arguments)

    print("xcgen \(self.commands.listCommands()) \(self.arguments.listArguments())")
  }
  
  public func start() throws {
    /// Change working directory
    main.currentdirectory = self.arguments[.workspaceDirectory]
    
    /// Fetch `.env` file
    let envFile = parseEnvFile(arguments: self.arguments)


    switch self.commands.primaryCommand {
    case .updateEnv:
      try commandUpdateEnv(arguments: arguments, envFile: envFile)
    }
  }
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
