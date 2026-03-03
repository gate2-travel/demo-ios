// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.1"
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
            checksum: "1c99eeff517674b2ac124a1988cbb92b27fe5e815dabaff1f1c06a3e43314ceb"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "5ff30bf14a32aec19c985fe024e6b561b8acbaabd066926f38d6fa6ec45e2d4e"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "a135aec39dc3cb669871f6598a9ecf9ac86528d3533b92090b11f7a583823aeb"
        ),
    ]
)
