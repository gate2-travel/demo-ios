// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.0"
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
            checksum: "c60bdc78a2659823711c01257a0acae407a27f1dca0f880856fbf223d6e687bb"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "9a3908cc44829399102e3ba3005ef09237b1bf14a499785ef4746cc863991b96"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "2b47dff4379cfaaf2f2cf362530355757f0ff398f82a645e96b7609bef166641"
        ),
    ]
)
