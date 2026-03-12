// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.6"
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
            checksum: "5f51844cbf3a52d4601556c94f6bdcbc738f3e9b34db922a29c6e3708e4a81c2"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "d00ba0dfc9258f3c06fc732370174ffd347353998047d032f2402573d1c046a1"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "c93545135f123ef7016264482040cad3cd40e9ec982c90122b2d3d8db28fd94e"
        ),
    ]
)
