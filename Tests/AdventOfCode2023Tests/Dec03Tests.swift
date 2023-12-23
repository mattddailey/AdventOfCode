import XCTest
@testable import AdventOfCode2023

final class Dec03Tests: XCTestCase {
  static let input =
  """
  """
  
  func testDec03Part1() throws {
    let day = Dec032023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, nil)
  }
    
  func testDec03Part2() throws {
    let day = Dec032023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, nil)
  }
}
