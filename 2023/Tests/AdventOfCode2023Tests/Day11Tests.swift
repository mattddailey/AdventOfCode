import XCTest
@testable import AdventOfCode2023

final class Day11Tests: XCTestCase {
  static let input =
  """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """
  
  func testDay11Part1() throws {
    let day = Day11()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 374)
  }
    
  func testDay11Part2() throws {
    let day = Day11()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 82000210)
  }
}
