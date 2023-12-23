import XCTest
@testable import AdventOfCode2023

final class Dec09Tests: XCTestCase {
  static let input =
  """
  """
  
  func testDec09Part1() throws {
    let day = Dec092023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, nil)
  }
    
  func testDec09Part2() throws {
    let day = Dec092023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, nil)
  }
}
