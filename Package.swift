// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Toastify",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Toastify", targets: ["Toastify"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Toastify", dependencies: []),
        .testTarget(name: "ToastifyTests", dependencies: ["Toastify"]),
    ]
)
