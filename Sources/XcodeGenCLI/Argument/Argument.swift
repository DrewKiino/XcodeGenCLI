//
//  Argument.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation
import SwiftShell

internal enum Argument: String, Codable, CaseIterable {
  case workspaceDirectory = "--workspace"
  case targets = "--targets"
  case envFile = "--env-file"
  case sourceFile = "--source-file"
  case targetFile = "--target-file"

  var defaultValue: String {
    switch self {
    case .workspaceDirectory: return run(bash: "pwd").stdout
    case .targets: return ""
    case .envFile: return ".env"
    case .sourceFile: return "project.json"
    case .targetFile: return "project.json"
    }
  }
  
  static func parse(_ argument: String) -> (Argument, String)? {
    let arguments = argument.split(separator: "=")
    if let flag = arguments.first.flatMap({ Argument(rawValue: $0.toString()) }), let value = arguments.last?.toString() {
      return (flag, value)
    }
    return nil
  }
}



