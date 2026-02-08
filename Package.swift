// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftConfettiView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftConfettiView",
            targets: ["SwiftConfettiView"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftConfettiView",
            path: "SwiftConfettiView",
            resources: [
                .process("Assets")
            ]
        ),
        .testTarget(
            name: "SwiftConfettiViewTests",
            dependencies: ["SwiftConfettiView"]
        ),
    ]
)
