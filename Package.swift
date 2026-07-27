// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BrowserTools",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "BrowserTools", targets: ["BrowserTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "8.11.0")
    ],
    targets: [
        .target(
            name: "BrowserTools",
            dependencies: ["Kingfisher"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
    ]
)
