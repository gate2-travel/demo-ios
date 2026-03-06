// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.4"
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
            checksum: "b9a4ddb5ed84e4dac9b35591e9cc4d344e030d1b77055c5663affa2960ea1063"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "039a3950b43f5be060a00c49aef2d68b62fece0786df101bb642a004c0f81d6a"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "8336a150472793d621ac01f5b024680ad8065f6e7d30beb2e72d62d9d58fd08f"
        ),
    ]
)
