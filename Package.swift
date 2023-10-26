// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PioneerHummingbird",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PioneerHummingbird",
            targets: ["PioneerHummingbird"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/d-exclaimation/pioneer", from: "1.4.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "1.9.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PioneerHummingbird",
            dependencies: [
                .product(name: "Pioneer", package: "pioneer"),
                .product(name: "Hummingbird", package: "hummingbird")
            ]
        ),
        .testTarget(
            name: "PioneerHummingbirdTests",
            dependencies: ["PioneerHummingbird"]),
    ]
)
