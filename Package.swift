// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.7"
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
            checksum: "cd00a52b55f5a505e93972bf393981ab6b875f19814f2f93cee2fb7d489ab604"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "ef5868cd705f845e53bfc52e8d5890579c9c3b2dd42f607e901abbd0d06768af"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "8628161295bbba588768610cc11dd01dfc41a55d9f30309b68c568a166735be5"
        ),
    ]
)
