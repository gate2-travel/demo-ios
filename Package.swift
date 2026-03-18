// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.10"
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
            checksum: "89bffbf36c6bcc0c2351412ddb512c56a2b8404c0ef3f3cb4be860c4645bfb50"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "9bad66358a1f007097bb73b699ddd6743a4829cbb4a5e7924a06af2b0d556b25"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "5b746e9aa2277cc328a28310d340ba0ea19a22b8ec908bbec983fe4603f751b1"
        ),
    ]
)
