// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ParkingLot",
    dependencies: [
    ],
    targets: [
        .target(
            name: "ParkingLot",
            dependencies: ["ParkingLotLib"]),
        .target(
            name: "ParkingLotLib"),
        .testTarget(
            name: "ParkingLotLibTests",
            dependencies: ["ParkingLotLib"]),
    ]
)
