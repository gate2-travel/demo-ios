// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.8"
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
            checksum: "1809ed99696f166eacf3b59887de653ba2dbdfae4c13abe1f74c30144d680a3c"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "c833f44e15b74c5edb8b356b30bc5a2eaa421932162c0f834a73d88ab0166403"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "83379e7382bf25f61f3969a38ebe1c9c326ad141aa4d962663e20d0bb6c6a3e1"
        ),
    ]
)
