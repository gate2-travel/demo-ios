// swift-tools-version: 5.9
import PackageDescription

let version = "1.3.1"
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
            checksum: "ec4094b3e199702b4106657acddf8f1802e112f13f45262a9851c68ce3a0893b"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "aeb5b039df0422b737b8ca4cd1adcb053b9e34c31ec1d7fee1b20368f9996767"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "0d81069064d9ff50b62efd2ef04c7e5545a96976683c5c537420551533c088d1"
        ),
    ]
)
