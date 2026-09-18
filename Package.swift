// swift-tools-version: 5.9
import PackageDescription

let version = "1.9.0"
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
            checksum: "8ac4fa2c1f7c56be72c633b635d505d4954c873ee5ebdb4da075649f7da14e59"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "ce30abf5e04225a86ce181995544f1257aaa3b3bf9429b5b6eff52c65e07d24a"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "6d36539b1e7807276e98112b26a682308524f380f52e7b68df95753cb49edac4"
        ),
    ]
)
