// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Smith",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "Smith",
            targets: ["Smith"]),
    ],
    dependencies: [
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "Smith",
            dependencies: ["Archivable"],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Smith"],
            path: "Tests"),
    ]
)
