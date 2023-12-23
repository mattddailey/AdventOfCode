import XCTest
@testable import AdventOfCode2023

final class Dec03Tests: XCTestCase {
  static let input =
  """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """
  
  func testDec03Part1() throws {
    let day = Dec032023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 4361)
  }
    
  func testDec03Part2() throws {
    let day = Dec032023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 467835)
  }
}
