// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-cyclic-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Cyclic Primitives",
            targets: ["Cyclic Primitives"]
        ),
        .library(
            name: "Cyclic Primitives Test Support",
            targets: ["Cyclic Primitives Test Support"]
        )
    ],
    dependencies: [
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-hash-primitives"),
        .package(path: "../swift-ordinal-primitives"),
        .package(path: "../swift-cardinal-primitives"),
        .package(path: "../swift-sequence-primitives"),
    ],
    targets: [
        .target(
            name: "Cyclic Primitives",
            dependencies: [
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Sequence Primitives", package: "swift-sequence-primitives"),
            ]
        ),
        .target(
            name: "Cyclic Primitives Test Support",
            dependencies: ["Cyclic Primitives"],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Cyclic Primitives Tests",
            dependencies: [
                "Cyclic Primitives",
                "Cyclic Primitives Test Support"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
