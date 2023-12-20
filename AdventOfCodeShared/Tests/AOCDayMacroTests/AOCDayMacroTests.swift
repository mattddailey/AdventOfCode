import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import AOCDayMacro

final class AOCDayMacroTests: XCTestCase {
  let testMacros: [String: Macro.Type] = [
    "AOCDay": AOCDayMacro.self
  ]
  
  func testAOCDayMacro_NoName() {
    assertMacroExpansion(
        """
        @AOCDay
        struct Dec202022 {
        }
        """,
        expandedSource:
        """
        struct Dec202022 {

            static let configuration = CommandConfiguration(abstract: "Advent of Code - December 20, 2022")

            mutating func run() async throws {
              let input = try await Input(day: 20, year: 2022)

              print("Part 1: \\(part1(input.asLines))")
              print("Part 2: \\(part2(input.asLines))")
            }
        }
        """,
        macros: testMacros
    )
  }
  
  func testAOCDayMacro_Name() {
    assertMacroExpansion(
        """
        @AOCDay(name: "DayName")
        struct Dec202022 {
        }
        """,
        expandedSource:
        """
        struct Dec202022 {

            static let configuration = CommandConfiguration(abstract: "Advent of Code - December 20, 2022 - DayName")

            mutating func run() async throws {
              let input = try await Input(day: 20, year: 2022)

              print("Part 1: \\(part1(input.asLines))")
              print("Part 2: \\(part2(input.asLines))")
            }
        }
        """,
        macros: testMacros
    )
  }
}
