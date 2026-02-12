// swift-tools-version: 5.9
import PackageDescription

let version = "1.1.0"
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
            checksum: "0dfe22154b041057a2cecd335a357afb7cc47178312dbc2b3d3cbb5e1d5208db"
        ),
        .binaryTarget(
            name: "Gate2TravelESims",
            url: "\(baseURL)/Gate2TravelESims.xcframework.zip",
            checksum: "3a22099e9c6d6edf6a329548fa3d6a7fc42b2cd4c85f7e4b8571fabeaddc7848"
        ),
        .binaryTarget(
            name: "Gate2TravelSDK",
            url: "\(baseURL)/Gate2TravelSDK.xcframework.zip",
            checksum: "3df138de2e78afe2a9b81536fb7eaa484983491b2849bc5d7dff0415b92d7709"
        ),
    ]
)
