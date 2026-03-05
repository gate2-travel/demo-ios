// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.3"
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
            checksum: "ae23048a1ee868da9efd25575baac605ccc3b5470c518e1e41d69c87ce0d216f"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "9f73377a4427d30b217964e645682f811030ba015e67d85ff2fe70fc084aa3da"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "102ab2d7f046a98e71980358c60c7be74240cdbba3c73828ce81c20601630131"
        ),
    ]
)
