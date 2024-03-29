import XCTest
@testable import AdventOfCode2023

final class Dec01Tests: XCTestCase {
  func testDec01() throws {
    let day1 = Dec012023()
    
    XCTAssertEqual(
      try day1.part1(
        """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """
      ) as? Int,
      142
    )
    
    XCTAssertEqual(
      try day1.part2(
        """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
        """
      ) as? Int,
      281
    )
  }
}
