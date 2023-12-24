import XCTest
@testable import AdventOfCode2023

final class Dec09Tests: XCTestCase {
  static let input =
  """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """
  
  func testDec09Part1() throws {
    let day = Dec092023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 114)
  }
    
  func testDec09Part2() throws {
    let day = Dec092023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 2)
  }
}
