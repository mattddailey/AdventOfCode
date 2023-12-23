import XCTest
@testable import AdventOfCode2023

final class Day07Tests: XCTestCase {
  static let input =
  """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """
  
  func testDay07Part1() throws {
    let day = Day07()
    XCTAssertEqual(day.part1(Self.input) as? Int, 6440)
  }
    
  func testDay07Part2() throws {
    let day = Day07()
    XCTAssertEqual(day.part2(Self.input) as? Int, 5905)
  }
}
