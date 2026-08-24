// swift-tools-version: 5.9
import PackageDescription

let version = "1.8.0"
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
            checksum: "3c2101e335bb7b4e25c18c1cd72a6d12e40c4bd85c2196152a15047f60f468c4"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "1ac68b0ed0f8594116dc434b49d23495e50e3b99e28416464ead45976e809b90"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "9eb340fc718a0c22c9490694e1f2fe8c06043eea2a54d38f8329954e883bc96b"
        ),
    ]
)
