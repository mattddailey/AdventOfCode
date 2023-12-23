import XCTest
@testable import AdventOfCode2023

final class Day03Tests: XCTestCase {
  static let input =
  """
  """
  
  func testDay03Part1() throws {
    let day = Dec032023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 0)
  }
    
  func testDay09Part2() throws {
    let day = Dec032023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 0)
  }
}
