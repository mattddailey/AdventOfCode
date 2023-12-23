import XCTest
@testable import AdventOfCode2023

final class Day06Tests: XCTestCase {
  static let input =
  """
  Time:      7  15   30
  Distance:  9  40  200
  """
  
  func testDay06Part1() throws {
    let day = Day06()
    XCTAssertEqual(day.part1(Self.input) as? Int, 288)
  }
    
  func testDay06Part2() throws {
    let day = Day06()
    XCTAssertEqual(day.part2(Self.input) as? Int, 71503)
  }
}
