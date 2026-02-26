// swift-tools-version: 5.9
import PackageDescription

let version = "1.4.0"
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
            checksum: "5ac2ea9d9062e4c36d8c339b8c7b00081ad28fd1a940a39f9d52c5ec86caac0b"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "edbe535eeacd33e811a96f2865221a72f59a4aeca3f1235b26324f6f3f8ff5a3"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "0807c76b91d245710268c55fcbb1a4874de509d80df57087993f086f73ea280a"
        ),
    ]
)
