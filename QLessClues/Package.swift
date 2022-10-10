// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "QLessClues",
	platforms: [
		.iOS(.v16),
	],
	products: [
		.library(name: "AnalysisFeature", targets: ["AnalysisFeature"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "DictionaryLibrary", targets: ["DictionaryLibrary"]),
		.library(name: "ExtensionsLibrary", targets: ["ExtensionsLibrary"]),
		.library(name: "HintsFeature", targets: ["HintsFeature"]),
		.library(name: "NetworkingService", targets: ["NetworkingService"]),
		.library(name: "PersistentModelsLibrary", targets: ["PersistentModelsLibrary"]),
		.library(name: "PlayFeature", targets: ["PlayFeature"]),
		.library(name: "PlaysListFeature", targets: ["PlaysListFeature"]),
		.library(name: "RecordPlayFeature", targets: ["RecordPlayFeature"]),
		.library(name: "SharedModelsLibrary", targets: ["SharedModelsLibrary"]),
		.library(name: "SharedModelsLibraryMocks", targets: ["SharedModelsLibraryMocks"]),
		.library(name: "StatisticsFeature", targets: ["StatisticsFeature"]),
		.library(name: "SolverServiceInterface", targets: ["SolverServiceInterface"]),
		.library(name: "SolverServiceLive", targets: ["SolverServiceLive"]),
		.library(name: "SolutionsListFeature", targets: ["SolutionsListFeature"]),
		.library(name: "ValidatorServiceInterface", targets: ["ValidatorServiceInterface"]),
		.library(name: "ValidatorServiceLive", targets: ["ValidatorServiceLive"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.40.2"),
		.package(url: "https://github.com/realm/realm-swift.git", from: "10.31.0"),
	],
	targets: [
		.target(
			name: "AnalysisFeature",
			dependencies: [
				"HintsFeature",
				"SolutionsListFeature",
				"SolverServiceInterface",
			]
		),
		.testTarget(
			name: "AnalysisFeatureTests",
			dependencies: [
				"AnalysisFeature",
				"SharedModelsLibraryMocks",
			]
		),
		.target(
			name: "AppFeature",
			dependencies: ["StatisticsFeature"]
		),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: ["AppFeature"]
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
			name: "HintsFeature",
			dependencies: [
				"DictionaryLibrary",
				"SharedModelsLibrary",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(
			name: "HintsFeatureTests",
			dependencies: [
				"HintsFeature",
				"SharedModelsLibraryMocks",
			]
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
			name: "PersistentModelsLibrary",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "RealmSwift", package: "realm-swift"),
			]
		),
		.target(
			name: "PlayFeature",
			dependencies: ["AnalysisFeature"]
		),
		.testTarget(
			name: "PlayFeatureTests",
			dependencies: [
				"PlayFeature",
				"SharedModelsLibraryMocks",
			]
		),
		.target(
			name: "PlaysListFeature",
			dependencies: [
				"PlayFeature",
				"RecordPlayFeature",
			]
		),
		.testTarget(
			name: "PlaysListFeatureTests",
			dependencies: [
				"PlaysListFeature",
				"SharedModelsLibraryMocks",
			]
		),
		.target(
			name: "RecordPlayFeature",
			dependencies: ["AnalysisFeature"]
		),
		.testTarget(
			name: "RecordPlayFeatureTests",
			dependencies: ["RecordPlayFeature"]
		),
		.target(
			name: "SharedModelsLibrary",
			dependencies: ["ExtensionsLibrary"]
		),
		.target(
			name: "SharedModelsLibraryMocks",
			dependencies: ["SharedModelsLibrary"]
		),
		.testTarget(
			name: "SharedModelsLibraryTests",
			dependencies: [
				"SharedModelsLibrary",
				"SharedModelsLibraryMocks",
			]
		),
		.target(
			name: "StatisticsFeature",
			dependencies: [
				"PlaysListFeature",
				"RecordPlayFeature",
			]
		),
		.testTarget(
			name: "StatisticsFeatureTests",
			dependencies: [
				"StatisticsFeature",
				"SharedModelsLibraryMocks",
			]
		),
		.target(
			name: "SolverServiceInterface",
			dependencies: ["ValidatorServiceInterface"]
		),
		.target(
			name: "SolverServiceLive",
			dependencies: [
				"SolverServiceInterface",
				"ValidatorServiceLive",
			]
		),
		.testTarget(
			name: "SolverServiceLiveTests",
			dependencies: ["SolverServiceLive"]
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
			dependencies: ["ValidatorServiceInterface"]
		),
		.testTarget(
			name: "ValidatorServiceLiveTests",
			dependencies: ["ValidatorServiceLive"]
		),
	]
)
