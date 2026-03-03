// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.2"
let baseURL = "https://github.com/gate2-travel/demo-ios/releases/download/v\(version)"

let package = Package(
    name: "Gate2TravelSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Gate2TravelSDK", targets: ["Gate2TravelCore", "Gate2TravelESims", "Gate2TravelSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "Gate2TravelCore",
            url: "\(baseURL)/Gate2TravelCore.xcframework.zip",
            checksum: "55232d5ea779b7b259cc67517768c8aef3d734342d50944cc57d4c44e6edd59e"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "bd24f79e705bda356bc6664c06d34af7d3f6334c8c0744f654c93835fffd2f0f"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "0531a91c7a8674d82dd399b75db6432c90f930e2a67f794a22238de07dab78d8"
        ),
    ]
)
