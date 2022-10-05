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
		.library(name: "DictionaryLibrary", targets: ["DictionaryLibrary"]),
		.library(name: "ExtensionsLibrary", targets: ["ExtensionsLibrary"]),
		.library(name: "NetworkingService", targets: ["NetworkingService"]),
		.library(name: "SharedModelsLibrary", targets: ["SharedModelsLibrary"]),
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
			name: "DictionaryLibrary",
			dependencies: []
		),
		.testTarget(
			name: "DictionaryLibraryTests",
			dependencies: ["DictionaryLibrary"]
		),
		.target(
			name: "ExtensionsLibrary",
			dependencies: []
		),
		.testTarget(
			name: "ExtensionsLibraryTests",
			dependencies: ["ExtensionsLibrary"]
		),
		.target(
			name: "NetworkingService",
			dependencies: []
		),
		.testTarget(
			name: "NetworkingServiceTests",
			dependencies: ["NetworkingService"]
		),
		.target(
			name: "SharedModelsLibrary",
			dependencies: ["ExtensionsLibrary"]
		),
		.testTarget(
			name: "SharedModelsLibraryTests",
			dependencies: ["SharedModelsLibrary"]
		),
	]
)
