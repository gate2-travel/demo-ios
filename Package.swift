// swift-tools-version: 5.9
import PackageDescription

let version = "1.6.1"
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
            checksum: "8d667a82fc94bdb7e44a551306749c5697ab41931bc7b7c51334ad46673f3a5d"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "634bb3d32ea871a4012e31a2cf3f4b42275f4ad23f508a32b21fbb8b13080f17"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "d31ad013db836f31e3fbe2bd62b20a0aaa50691526b07c392042bdf7828e21b7"
        ),
    ]
)
