//
//  String+.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation

internal extension Substring {
  func toString() -> String { String(self) }
}

internal extension String {
  func toStringArray() -> [String] {
    split(separator: ",").map { $0.toString() }
  }
}


