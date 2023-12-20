//
//  AdventOfCodeDay.swift
//
//
//  Created by Matt Dailey on 11/30/23.
//

import Foundation

public protocol AdventOfCodeDay {
  func part1(_ input: String) throws -> CustomStringConvertible
  func part2(_ input: String) throws -> CustomStringConvertible
}
