//
//  Arguments.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation

internal struct Arguments: Codable {
  private let arguments: [Argument: String]
  
  init(_ arguments: [Argument: String]) {
    // let defaultArgs = Dictionary(Argument.allCases.map { ($0, $0.defaultValue) }, uniquingKeysWith: { $1 })
    self.arguments = arguments
  }
  
  init(_ arguments: [String]) {
    self.init(Dictionary(arguments.compactMap(Argument.parse), uniquingKeysWith: { $1 }))
  }
  
  subscript(_ argument: Argument) -> String {
    self.arguments[argument] ?? ProcessInfo.processInfo.environment[argument.rawValue] ?? argument.defaultValue
  }

  func listArguments() -> String {
    return self.arguments
      .map { flag, value in "\(flag.rawValue)=\(value)" }
      .joined(separator: " ")
  }
}
