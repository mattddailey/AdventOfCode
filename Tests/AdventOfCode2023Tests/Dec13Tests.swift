import XCTest
@testable import AdventOfCode2023

final class Dec13Tests: XCTestCase {
  static let input =
  """
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  """
  
  func testDec13Part1() throws {
    let day = Dec132023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 405)
  }
    
  func testDec11Part2() throws {
    let day =  Dec132023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 400)
  }
}
