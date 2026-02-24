// swift-tools-version: 5.9
import PackageDescription

let version = "1.3.2"
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
            checksum: "66a397b1384d6053d744e3fb298070ca1aa11e63eb3aca4c8c7e30fc3d287412"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "f005f58012eaf6db0f0f5c567ea53a2c74c7e8e5734e9bc16028a147b598027a"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "92f95a2609bf774fed48e1a655598c8b8e5851f0ea323cf92ed21bc409bfacf8"
        ),
    ]
)
