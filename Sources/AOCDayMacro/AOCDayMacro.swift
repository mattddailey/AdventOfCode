import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AOCDayMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [SwiftSyntax.DeclSyntax] {
    let dayName: String? = if case .argumentList(let arguments) = node.arguments {
      arguments
        .first?.as(LabeledExprSyntax.self)?
        .expression.as(StringLiteralExprSyntax.self)?
        .segments.first?.as(StringSegmentSyntax.self)?
        .content.text
    } else {
      nil
    }
    
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw AOCDayError.onlyApplicableToStruct
    }
    
    let structName = structDecl.name.text
    let dayModel = try dayModel(for: structName)
    
    var configuration = "static let configuration = CommandConfiguration(abstract: \"Advent of Code - December \(dayModel.day), \(dayModel.year)"
    
    if let dayName {
      configuration += " - \(dayName)\")"
    } else {
      configuration += "\")"
    }
    
    let runFunc =
    """
    mutating func run() async throws {
      let input = try await inputFor(day: \(dayModel.day), year: \(dayModel.year))

      print("Part 1: \\(try part1(input))")
      print("Part 2: \\(try part2(input))")
    }
    """
    
    return [
      DeclSyntax(stringLiteral: configuration),
      DeclSyntax(stringLiteral: runFunc)
    ]
  }
  
  
  static private func dayModel(for structName: String) throws -> AOCDayModel {
    let structNamePattern = #"Dec[0-9]+"#
    let regex = try Regex(structNamePattern)
    
    guard let result = structName.firstMatch(of: regex) else {
      throw AOCDayError.nameIncorrectlyFormatted
    }
    
    let match = result.0
    
    guard match.count == 9 else {
      throw AOCDayError.nameIncorrectlyFormatted
    }
    
    let dayAndYear = match.suffix(6)
    
    guard
      let day = Int(dayAndYear.prefix(2)),
      let year = Int(dayAndYear.suffix(4))
    else  {
      throw AOCDayError.nameIncorrectlyFormatted
    }
    
    return AOCDayModel(
      day: day,
      year: year
    )
  }
  
  struct AOCDayModel {
    let day: Int
    let year: Int
  }
}


@main
struct AOCDayPackagePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    AOCDayMacro.self
  ]
}
