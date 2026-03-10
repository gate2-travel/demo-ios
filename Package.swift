// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.5"
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
            checksum: "676f5aee10f60796512d8c90b324e4f97d5f6d0bd602b3579a991f23761e0e05"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "f7d3264357f9e20755a5364bc3cf1265646123f2800e7bfbf050bbf2ec846349"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "51ea66c2b7114b6430d434a84cb5e6505dd4b274e0b7adcb0b4f8db37031cbb9"
        ),
    ]
)
