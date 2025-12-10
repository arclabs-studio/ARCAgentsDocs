// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARCAgentsDocs",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        // Documentation package - no library, just resources
        .library(
            name: "ARCAgentsDocs",
            targets: ["ARCAgentsDocs"]
        )
    ],
    targets: [
        // Documentation target with all markdown files as resources
        .target(
            name: "ARCAgentsDocs",
            path: ".",
            exclude: [
                "Sources",
                ".git",
                ".github",
                "Package.swift",
                "LICENSE",
                ".gitignore",
                ".gitattributes"
            ],
            resources: [
                .copy("Documentation"),
                .copy("CLAUDE.md"),
                .copy("README.md"),
                .copy("CHANGELOG.md")
            ]
        )
    ]
)
