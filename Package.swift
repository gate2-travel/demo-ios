// swift-tools-version: 5.9
import PackageDescription

let version = "1.1.1"
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
            checksum: "97cf5c20b9cb5ff4a22dcf56b85f600fc02510279a883a9e56bef89eddadfc80"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "7df2ac194ad7dd368aa7a0ccff0d55d9508076bedc8c86036b9605b9edc2f3e9"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "08011db3ea2c53b1ae2248352c97ee6e9fd07914f3089bd9c0ee366cb6716211"
        ),
    ]
)
