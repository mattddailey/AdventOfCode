// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2023",
    platforms: [.macOS(.v13)],
    dependencies: [
      .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
      .package(path: "../AdventOfCodeShared")
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode2023",
            dependencies: [
              .product(name: "Algorithms", package: "swift-algorithms"),
              .product(name: "ArgumentParser", package: "swift-argument-parser"),
              .product(name: "AdventOfCodeShared", package: "AdventOfCodeShared")
            ]
        ),
        .testTarget(
            name: "AdventOfCode2023Tests",
            dependencies: [
              "AdventOfCode2023",
              "AdventOfCodeShared"
            ]
        ),
    ]
)

for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []

    target.swiftSettings?.append(contentsOf: [
        .enableUpcomingFeature("BareSlashRegexLiterals")
    ])
}
