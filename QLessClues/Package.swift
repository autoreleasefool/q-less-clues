// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "QLessClues",
	platforms: [
		.iOS(.v16),
	],
	products: [
		.library(name: "AppCore", targets: ["AppCore"]),
		.library(name: "DictionaryLibrary", targets: ["DictionaryLibrary"]),
		.library(name: "ExtensionsLibrary", targets: ["ExtensionsLibrary"]),
		.library(name: "NetworkingService", targets: ["NetworkingService"]),
		.library(name: "SharedModelsLibrary", targets: ["SharedModelsLibrary"]),
		.library(name: "SolutionsListFeature", targets: ["SolutionsListFeature"]),
		.library(name: "ValidatorServiceInterface", targets: ["ValidatorServiceInterface"]),
		.library(name: "ValidatorServiceLive", targets: ["ValidatorServiceLive"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.40.2"),
		.package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.4.1"),
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
		.target(
			name: "SolutionsListFeature",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(
			name: "SolutionsListFeatureTests",
			dependencies: ["SolutionsListFeature"]
		),
		.target(
			name: "ValidatorServiceInterface",
			dependencies: [
				"DictionaryLibrary",
				"SharedModelsLibrary",
			]
		),
		.target(
			name: "ValidatorServiceLive",
			dependencies: [
				"DictionaryLibrary",
				"SharedModelsLibrary",
				"ValidatorServiceInterface",
			]
		),
		.testTarget(
			name: "ValidatorServiceLiveTests",
			dependencies: ["ValidatorServiceLive"]
		),
	]
)
