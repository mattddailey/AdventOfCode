import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import AOCDayMacro

let testMacros: [String: Macro.Type] = [
    "AOCDay": AOCDayMacro.self,
]

final class AOCDayTests: XCTestCase {
    func testAOCDay_Name() throws {
      assertMacroExpansion(
          """
          @AOCDay(name: "test")
          struct Dec012023 {
          }
          """,
          expandedSource: """
          struct Dec012023 {

              static let configuration = CommandConfiguration(abstract: "Advent of Code - December 1, 2023 - test")

              mutating func run() async throws {
                let input = try await inputFor(day: 1, year: 2023)

                print("Part 1: \\(try part1(input))")
                print("Part 2: \\(try part2(input))")
              }
          }
          """,
          macros: testMacros
      )
    }
  
  func testAOCDay_NoName() throws {
    assertMacroExpansion(
        """
        @AOCDay
        struct Dec012023 {
        }
        """,
        expandedSource: """
        struct Dec012023 {

            static let configuration = CommandConfiguration(abstract: "Advent of Code - December 1, 2023")

            mutating func run() async throws {
              let input = try await inputFor(day: 1, year: 2023)

              print("Part 1: \\(try part1(input))")
              print("Part 2: \\(try part2(input))")
            }
        }
        """,
        macros: testMacros
    )
  }
}
