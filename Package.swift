// swift-tools-version: 5.9
//
// Created By - Madan Kumawat 
// linkedin Profile - https://in.linkedin.com/in/madankumawat
// Topmate - https://topmate.io/madank
//
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartImageView",
    platforms: [
        .iOS(.v16) // Support iOS 16 and later
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmartImageView",
            targets: ["SmartImageView"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SmartImageView"),
        .testTarget(
            name: "SmartImageViewTests",
            dependencies: ["SmartImageView"]),
    ]
)
