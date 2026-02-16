// swift-tools-version: 5.9
import PackageDescription

let version = "1.2.0"
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
            checksum: "7d82bc96a58e8367648021568a8684ec1294ed89661e0dce887505fcd01eae59"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "dbce27608d12a708fe7178efc86f2d58df0693a2ff0892767b8cc2a95eea2cb1"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "51ec9eb8aaab6123b1b8ff7bb41df6a0f0bd59938155cb635f29d74abb2f857f"
        ),
    ]
)
