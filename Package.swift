// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftSDAIcore",
	platforms: [
		.macOS(.v26)
	],
	products: [
		.library(
			name: "SwiftSDAIcore",
			targets: ["SwiftSDAIcore"]),
	],
	dependencies: [
	],
	targets: [
		.target(
			name: "SwiftSDAIcore",
			dependencies: []),
		.testTarget(
			name: "SwiftSDAIcoreTests",
			dependencies: ["SwiftSDAIcore"]),
	]
)



