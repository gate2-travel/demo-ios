// swift-tools-version: 5.9
import PackageDescription

let version = "1.5.9"
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
            checksum: "ef79df0f9277d5c8cfecaa59cc41d10443ab76e28f9373c240dc32fc743b8779"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "bb7b13c83339d46052b34fd196f7fe2764481464fc31c661decdc357a59e886c"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "6c8523271b1aabf4e73de0a2cbfe5f4ee7ff59bd1c9fb468f086cc76b0a6bf8f"
        ),
    ]
)
