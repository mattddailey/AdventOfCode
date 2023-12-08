//
//  AdventOfCodeError.swift
//
//
//  Created by Matt Dailey on 12/8/23.
//

import Foundation

public struct AdventOfCodeError: Error {
  let description: String?
  
  public init(_ description: String?) {
    self.description = description
  }
}
