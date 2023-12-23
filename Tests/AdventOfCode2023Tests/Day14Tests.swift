import XCTest
@testable import AdventOfCode2023

final class Day14Tests: XCTestCase {
  static let input =
    """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

  
  func testDay14Part1() throws {
    let day = Day14()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 136)
  }
    
  func testDay14Part2() throws {
    let day = Day14()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 64)
  }
}
