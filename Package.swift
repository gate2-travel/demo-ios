// swift-tools-version: 5.9
import PackageDescription

let version = "1.2.2"
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
            checksum: "022c073d8e92f06ac989f3925c6854521803ed085c121e81d128524a7cd2dfc3"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "c64c24c678f5464d181912faea12c079ece19ff238e8ebea583228c9d27fd235"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "2964f862776e0bc4adb8ede09b7e43b73e68b8ba76abfb61c186f98f257ec589"
        ),
    ]
)
