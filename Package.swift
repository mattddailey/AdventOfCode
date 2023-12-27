// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
      .macOS(.v13), .iOS(.v16), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
      .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
    ],
    targets: [
      .executableTarget(
        name: "AdventOfCode2023",
        dependencies: [
          .product(name: "Algorithms", package: "swift-algorithms"),
          .product(name: "ArgumentParser", package: "swift-argument-parser"),
          "AdventOfCodeShared",
          "AOCDay"
        ]
      ),
      .target(
        name: "AdventOfCodeShared",
        resources: [.copy("cookie.json")]
      ),
      .target(
        name: "AOCDay",
        dependencies: ["AOCDayMacro"]
      ),
      .macro(
          name: "AOCDayMacro",
          dependencies: [
              .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
              .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
          ],
          swiftSettings: [
            .enableUpcomingFeature("BareSlashRegexLiterals")
          ]
      ),
      .testTarget(
        name: "AdventOfCode2023Tests",
        dependencies: ["AdventOfCode2023"]
      ),
      .testTarget(
          name: "AOCDayMacroTests",
          dependencies: [
              "AOCDayMacro",
              .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
          ]
      ),
    ]
)


for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []

    target.swiftSettings?.append(
      contentsOf: [
        .enableUpcomingFeature("BareSlashRegexLiterals")
      ]
    )
}
