// swift-tools-version: 5.9
import PackageDescription

let version = "1.3.0"
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
            checksum: "a8514a225ff15f325dfb240674cb968bbe5c45f8bc83208a6c594c575fd967c0"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "2cff4fda59c54df7224c88881ebbd7ab16039a7ff0dac6332671b609212e39c0"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "f51a3745f6bd356b94ec49702b1b7c3c9a8a8f8d11ba6eb0297f7cd32690d756"
        ),
    ]
)
