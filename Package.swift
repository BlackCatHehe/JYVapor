// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HelloVapor",
    products: [
        .library(name: "HelloVapor", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.1"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "3.1.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

