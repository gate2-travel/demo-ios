// swift-tools-version: 5.9
import PackageDescription

let version = "1.2.3"
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
            checksum: "874fe3a4c14c4feda6c016b3552b2ca9a832d4455f0c0a141e2062d287118f61"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "b3ff796437264bfab1ac98bfdac55797fbe51494b5c44db2807d03a4531faa40"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "eec99dbe91e112fcadac283c091b79261a75e441c750e66ff95ccb0e5a865c70"
        ),
    ]
)
