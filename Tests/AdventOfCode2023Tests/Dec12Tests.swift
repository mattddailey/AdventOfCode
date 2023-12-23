import XCTest
@testable import AdventOfCode2023

final class Dec12Tests: XCTestCase {
  static let input =
    """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

  
  func testDec12Part1() throws {
    let day = Dec122023()
    XCTAssertEqual(try day.part1(Self.input) as? Int, 21)
  }
    
  func testDec12Part2() throws {
    let day = Dec122023()
    XCTAssertEqual(try day.part2(Self.input) as? Int, 525152)
  }
}
