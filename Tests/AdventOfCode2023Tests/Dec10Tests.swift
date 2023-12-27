import XCTest
@testable import AdventOfCode2023

final class Dec10Tests: XCTestCase {
  static let inputPart1 =
  """
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  """
  
  static let inputPart2 =
  """
  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...
  """
  
  func testDec10Part1() throws {
    let day = Dec102023()
    XCTAssertEqual(try day.part1(Self.inputPart1) as? Int, 8)
  }
    
  func testDec10Part2() throws {
    let day =  Dec102023()
    XCTAssertEqual(try day.part2(Self.inputPart2) as? Int, 8)
  }
}
