import XCTest
@testable import AdventOfCode2023

final class Dec06Tests: XCTestCase {
  static let input =
  """
  Time:      7  15   30
  Distance:  9  40  200
  """
  
  func testDec06Part1() throws {
    let day = Dec062023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 288)
  }
    
  func testDec06Part2() throws {
    let day = Dec062023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 71503)
  }
}
