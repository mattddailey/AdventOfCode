import XCTest
@testable import AdventOfCode2023

final class Dec00Tests: XCTestCase {
  static let input =
  """
  """
  
  func testDec11Part1() throws {
    let day = Dec000000()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 0)
  }
    
  func testDec11Part2() throws {
    let day =  Dec000000()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 0)
  }
}
