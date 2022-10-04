// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "QLessClues",
	platforms: [
		.iOS(.v16),
	],
	products: [
		.library(name: "AppCore", targets: ["AppCore"]),
//		.library(name: "Validator", targets: ["Validator"]),
		.library(name: "Dictionary", targets: ["Dictionary"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.40.2"),
	],
	targets: [
		.target(
			name: "AppCore",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(
			name: "AppCoreTests",
			dependencies: ["AppCore"]
		),
//		.target(
//			name: "Validator",
//			dependencies: ["Dictionary"]
//		),
//		.testTarget(
//			name: "ValidatorTests",
//			dependencies: ["Validator"]
//		),
		.target(
			name: "Dictionary",
			dependencies: []
		),
		.testTarget(
			name: "DictionaryTests",
			dependencies: ["Dictionary"]
		),
	]
)
