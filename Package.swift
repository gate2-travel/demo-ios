// swift-tools-version: 5.9
import PackageDescription

let version = "1.6.0"
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
            checksum: "2d9880cd76c4b785c553d5a579a59b8f9dd66888c90fb65958daac6d68711e3f"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "402371218c0d3cd34fd4a7950df10aa4d5c9ed72ac79fbe61b12618ce1924297"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "bd67ad7e286417bae72b03948a3bbe75255bd2db74bf5ce6f42682185121e715"
        ),
    ]
)
