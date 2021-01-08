//
//  Dictionary+.swift
//  XcodeGenCLI
//
//  Created by Andrew Aquino on 1/7/21.
//

import Foundation

internal protocol Initializable {
  init()
}

extension Dictionary: Initializable {}

internal extension Dictionary where Key == String, Value == Any {
  mutating func mutateValue<T: Initializable>(_ key: String, closure: (inout T) -> ()) {
    var value = (self[key] as? T) ?? T()
    closure(&value)
    self[key] = value
  }
}
