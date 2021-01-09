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
    if split.count == 2,
       let key = split.first?.toString().trimmingCharacters(in: .whitespacesAndNewlines),
       let value = split.last?.toString().trimmingCharacters(in: .whitespacesAndNewlines) {
      return (key, value)
    }
    return nil
  }, uniquingKeysWith: { $1 })
}

