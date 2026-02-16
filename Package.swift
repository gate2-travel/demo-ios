// swift-tools-version: 5.9
import PackageDescription

let version = "1.2.1"
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
            checksum: "374076e228a8da224ef91eaa404d6984c11f6a831a6a08a118cf6ca079ecec99"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "61bd7bb02051c1b5bda2a689d9febb9e016eecb34bf6a3b7a04309bca6b97394"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "0641c71d6092fb67a6657029a9d8e18a6e73a87158381bc2ca0c3f0c272d1500"
        ),
    ]
)
