//
//  Util.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation
import SwiftShell

internal func parseEnvFile(arguments: Arguments) -> [String: String] {
  return Dictionary(run(bash: "cat \(arguments[.envFile])").stdout.split(separator: "\n").compactMap { argument -> (String, String)? in
    let split = argument.split(separator: "=")
    if let key = split.first?.toString(), let value = split.last?.toString() {
      return (key, value)
    }
    return nil
  }, uniquingKeysWith: { $1 })
}

