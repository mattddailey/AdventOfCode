//
//  String+Extensions.swift
//
//
//  Created by Matt Dailey on 12/4/23.
//

import Foundation

public extension String {
  var asInt: Int {
    Int(
      self.replacingOccurrences(
        of: "[^0-9]+",
        with: "",
        options: .regularExpression
      )
    ) ?? 0
  }
}
