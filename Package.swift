// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Gate2TravelSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Gate2TravelSDK", targets: ["Gate2TravelCore", "Gate2TravelESims", "Gate2TravelSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "Gate2TravelCore",
            path: "Frameworks/Gate2TravelCore.xcframework.zip"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            path: "Frameworks/Gate2TravelESims.xcframework.zip"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            path: "Frameworks/Gate2TravelSDK.xcframework.zip"
        ),
    ]
)
