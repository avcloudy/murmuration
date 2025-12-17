// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "murmuration", platforms: [.macOS(.v26)],
    products: [
        .library(name: "torrent", targets: ["torrent"]),
        .executable(name: "torrent-cli", targets: ["torrent-cli"]),
    ],
    targets: [
        .target(
            name: "torrent",
            resources: [
                .copy("Resources")
            ]),
        .executableTarget(
            name: "torrent-cli", dependencies: ["torrent"],
        ),
        .testTarget(name: "torrentTests", dependencies: ["torrent"]),
    ])
