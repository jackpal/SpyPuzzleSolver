// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpyPuzzleSolver",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SpyPuzzleSolver",
            targets: ["SpyPuzzleSolver"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Dev1an/A-Star", from: "2.1.0"),
        .package(url: "https://github.com/jackpal/SpyPuzzleGameState.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SpyPuzzleSolver",
            dependencies: [
                .product(name: "AStar", package: "A-Star"),
                "SpyPuzzleGameState"
                ]),
        .testTarget(
            name: "SpyPuzzleSolverTests",
            dependencies: ["SpyPuzzleSolver"]),
    ]
)
