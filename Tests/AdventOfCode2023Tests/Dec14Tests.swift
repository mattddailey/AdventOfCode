import XCTest
@testable import AdventOfCode2023

final class Dec14Tests: XCTestCase {
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

  
  func testDec14Part1() throws {
    let day = Dec142023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 136)
  }
    
  func testDec14Part2() throws {
    let day = Dec142023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 64)
  }
}
