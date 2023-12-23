import XCTest
@testable import AdventOfCode2023

final class Day12Tests: XCTestCase {
  static let input =
    """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

  
  func testDay12Part1() throws {
    let day = Day12()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 21)
  }
    
  func testDay12Part2() throws {
    let day = Day12()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 525152)
  }
}
