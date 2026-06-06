// swift-tools-version: 5.9
import PackageDescription

let version = "1.7.0"
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
            checksum: "34b42edfe83e73c2cf030c410d9402ddd02d6c7c69eb6cc4f602e86671d659b0"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "ce41e2af6e5865309c792ce9ec7fb03b0c434b5d7827af3260c644b317d2c376"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "58c2df04988eb3501d670ce07f3b899a506d69f411d92e181dfae2d22112fa19"
        ),
    ]
)
