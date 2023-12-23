//
//  Int+Extensions.swift
//
//
//  Created by Matt Dailey on 12/8/23.
//

import Foundation

public extension Array {
  var tail: Array {
    return Array(dropFirst())
  }
}
