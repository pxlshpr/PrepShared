// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrepShared",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PrepShared",
            targets: ["PrepShared"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/SwiftSugar", from: "0.0.97"),
        .package(url: "https://github.com/pxlshpr/SwiftHaptics", from: "0.1.4"),
        .package(url: "https://github.com/pxlshpr/VisionSugar", from: "0.0.80"),
        .package(url: "https://github.com/pxlshpr/ColorSugar", from: "0.0.8"),
        .package(url: "https://github.com/marmelroy/Zip", from: "2.1.2"),
        .package(url: "https://github.com/siteline/swiftUI-introspect", from: "1.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PrepShared",
            dependencies: [
                .product(name: "SwiftSugar", package: "SwiftSugar"),
                .product(name: "SwiftHaptics", package: "SwiftHaptics"),
                .product(name: "VisionSugar", package: "VisionSugar"),
                .product(name: "ColorSugar", package: "ColorSugar"),
                .product(name: "Zip", package: "Zip"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ]
        ),
        .testTarget(
            name: "PrepSharedTests",
            dependencies: ["PrepShared"]),
    ]
)
