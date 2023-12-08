import XCTest
@testable import AdventOfCode2023

final class Day08Tests: XCTestCase {
  static let part1Input =
  """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """
  
  static let part2Input =
  """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """
  
  func testDay08Part1() throws {
    let day = Day08()
    XCTAssertEqual(try day.part1(Self.part1Input) as? Int, 6)
  }
    
  func testDay08Part2() throws {
    let day = Day08()
    XCTAssertEqual(try day.part2(Self.part2Input) as? Int, 6)
  }
}
