//
//  UpdateEnv.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation
import SwiftShell

@available(OSX 10.13, *)
internal func commandUpdateEnv(
  arguments: Arguments,
  envFile: [String: Any]
) throws {
  let jsonString = run("cat", arguments[.sourceFile]).stdout
  if let data = jsonString.data(using: .utf8) {
    if var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
      json.mutateValue("targets") { (targets: inout [String: Any]) in
        /// Either loop through argument targets or all targets
        let targetsIterable: [String] = {
          let targetArgs = arguments[.targets].toStringArray()
          if targetArgs.isEmpty { return Array(targets.keys) }
          return targetArgs
        }()
        /// Perform loop
        for target in targetsIterable {
          targets.mutateValue(target) { (project: inout [String: Any]) in
            project.mutateValue("scheme") { (scheme: inout [String: Any]) in
              scheme.mutateValue("environmentVariables") { (envVars: inout [String: Any]) in
                /// Update the `.env` file with this project
                envVars = envFile
              }
            }
          }
        }
      }
      let newData =  try JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted])
      if let newJsonString = String(data: newData, encoding: .utf8) {
        run(bash: "echo '\(newJsonString)' > \(arguments[.targetFile])")
      }
    }
  }
}
