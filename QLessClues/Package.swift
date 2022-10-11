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
		.library(name: "PersistentModelsLibrary", targets: ["PersistentModelsLibrary"]),
		.library(name: "PersistenceService", targets: ["PersistenceService"]),
		.library(name: "PersistenceServiceInterface", targets: ["PersistenceServiceInterface"]),
		.library(name: "PlayFeature", targets: ["PlayFeature"]),
		.library(name: "PlaysDataProvider", targets: ["PlaysDataProvider"]),
		.library(name: "PlaysDataProviderInterface", targets: ["PlaysDataProviderInterface"]),
		.library(name: "PlaysListFeature", targets: ["PlaysListFeature"]),
		.library(name: "RecordPlayFeature", targets: ["RecordPlayFeature"]),
		.library(name: "SharedModelsLibrary", targets: ["SharedModelsLibrary"]),
		.library(name: "SharedModelsLibraryMocks", targets: ["SharedModelsLibraryMocks"]),
		.library(name: "StatisticsDataProvider", targets: ["StatisticsDataProvider"]),
		.library(name: "StatisticsDataProviderInterface", targets: ["StatisticsDataProviderInterface"]),
		.library(name: "StatisticsFeature", targets: ["StatisticsFeature"]),
		.library(name: "SolverService", targets: ["SolverService"]),
		.library(name: "SolverServiceInterface", targets: ["SolverServiceInterface"]),
		.library(name: "SolutionsListFeature", targets: ["SolutionsListFeature"]),
		.library(name: "ValidatorService", targets: ["ValidatorService"]),
		.library(name: "ValidatorServiceInterface", targets: ["ValidatorServiceInterface"]),
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
			dependencies: ["PlaysListFeature"]
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
			name: "PersistenceService",
			dependencies: [
				"PersistentModelsLibrary",
				"PersistenceServiceInterface",
			]
		),
		.testTarget(
			name: "PersistenceServiceTests",
			dependencies: ["PersistenceService"]
		),
		.target(
			name: "PersistenceServiceInterface",
			dependencies: [
				.product(name: "RealmSwift", package: "realm-swift"),
			]
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
			name: "PlaysDataProvider",
			dependencies: [
				"PersistenceServiceInterface",
				"PersistentModelsLibrary",
				"PlaysDataProviderInterface",
			]
		),
		.testTarget(
			name: "PlaysDataProviderTests",
			dependencies: ["PlaysDataProvider"]
		),
		.target(
			name: "PlaysDataProviderInterface",
			dependencies: ["PersistentModelsLibrary"]
		),
		.target(
			name: "PlaysListFeature",
			dependencies: [
				"PlayFeature",
				"RecordPlayFeature",
				"StatisticsFeature",
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
			name: "StatisticsDataProvider",
			dependencies: [
				"PersistenceServiceInterface",
				"PersistentModelsLibrary",
				"StatisticsDataProviderInterface",
			]
		),
		.testTarget(
			name: "StatisticsDataProviderTests",
			dependencies: ["StatisticsDataProvider"]
		),
		.target(
			name: "StatisticsDataProviderInterface",
			dependencies: ["PersistentModelsLibrary"]
		),
		.target(
			name: "StatisticsFeature",
			dependencies: [
				"StatisticsDataProviderInterface",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
			name: "SolverService",
			dependencies: [
				"SolverServiceInterface",
				"ValidatorService",
			]
		),
		.testTarget(
			name: "SolverServiceTests",
			dependencies: ["SolverService"]
		),
		.target(
			name: "SolverServiceInterface",
			dependencies: ["ValidatorServiceInterface"]
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
			name: "ValidatorService",
			dependencies: ["ValidatorServiceInterface"]
		),
		.testTarget(
			name: "ValidatorServiceTests",
			dependencies: ["ValidatorService"]
		),
		.target(
			name: "ValidatorServiceInterface",
			dependencies: [
				"DictionaryLibrary",
				"SharedModelsLibrary",
			]
		),
	]
)
