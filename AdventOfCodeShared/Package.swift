// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCodeShared",
    products: [
        .library(
            name: "AdventOfCodeShared",
            targets: ["AdventOfCodeShared"]),
    ],
    targets: [
        .target(
            name: "AdventOfCodeShared")
    ]
)
