//
//  Commands.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation

internal struct Commands: Codable {
  private let commands: [Command]
  
  public let primaryCommand: Command

  init?(_ arguments: [String]) {
    let commands = arguments.compactMap(Command.init(rawValue:))
    guard let command = commands.first else { return nil }
    self.primaryCommand = command
    self.commands = commands
  }
  
  func listCommands() -> String {
    return self.commands.map { $0.rawValue }.joined(separator: " ")
  }
}
