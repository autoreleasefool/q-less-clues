// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "QLessClues",
	platforms: [
		.iOS(.v16),
	],
	products: [
		// MARK: - Features
		.library(name: "AnalysisFeature", targets: ["AnalysisFeature"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "HintsFeature", targets: ["HintsFeature"]),
		.library(name: "PlayDetailsFeature", targets: ["PlayDetailsFeature"]),
		.library(name: "PlaysListFeature", targets: ["PlaysListFeature"]),
		.library(name: "RecordPlayFeature", targets: ["RecordPlayFeature"]),
		.library(name: "StatisticsFeature", targets: ["StatisticsFeature"]),
		.library(name: "SolutionsListFeature", targets: ["SolutionsListFeature"]),

		// MARK: - DataProviders
		.library(name: "PlaysDataProvider", targets: ["PlaysDataProvider"]),
		.library(name: "PlaysDataProviderInterface", targets: ["PlaysDataProviderInterface"]),
		.library(name: "StatisticsDataProvider", targets: ["StatisticsDataProvider"]),
		.library(name: "StatisticsDataProviderInterface", targets: ["StatisticsDataProviderInterface"]),

		// MARK: - Services
		.library(name: "PersistenceService", targets: ["PersistenceService"]),
		.library(name: "PersistenceServiceInterface", targets: ["PersistenceServiceInterface"]),
		.library(name: "SolverService", targets: ["SolverService"]),
		.library(name: "SolverServiceInterface", targets: ["SolverServiceInterface"]),
		.library(name: "ValidatorService", targets: ["ValidatorService"]),
		.library(name: "ValidatorServiceInterface", targets: ["ValidatorServiceInterface"]),

		// MARK: - Libraries
		.library(name: "DictionaryLibrary", targets: ["DictionaryLibrary"]),
		.library(name: "ExtensionsLibrary", targets: ["ExtensionsLibrary"]),
		.library(name: "PersistentModelsLibrary", targets: ["PersistentModelsLibrary"]),
		.library(name: "SharedModelsLibrary", targets: ["SharedModelsLibrary"]),
		.library(name: "SharedModelsLibraryMocks", targets: ["SharedModelsLibraryMocks"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.43.0"),
		.package(url: "https://github.com/groue/GRDB.swift.git", from: "6.1.0"),
	],
	targets: [
		// MARK: - Features
		.target(
			name: "AnalysisFeature",
			dependencies: [
				"HintsFeature",
				"SolutionsListFeature",
				"SolverServiceInterface",
			]
		),
		.testTarget(name: "AnalysisFeatureTests", dependencies: ["AnalysisFeature", "SharedModelsLibraryMocks"]),
		.target(name: "AppFeature", dependencies: ["PlaysListFeature"]),
		.testTarget(name: "AppFeatureTests", dependencies: ["AppFeature"]),
		.target(
			name: "HintsFeature",
			dependencies: [
				"DictionaryLibrary",
				"SharedModelsLibrary",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(name: "HintsFeatureTests", dependencies: ["HintsFeature", "SharedModelsLibraryMocks"]),
		.target(
			name: "PlayDetailsFeature",
			dependencies: [
				"AnalysisFeature",
				"PlaysDataProviderInterface",
			]
		),
		.testTarget(name: "PlayDetailsFeatureTests", dependencies: ["PlayDetailsFeature", "SharedModelsLibraryMocks"]),
		.target(
			name: "PlaysListFeature",
			dependencies: [
				"PlayDetailsFeature",
				"RecordPlayFeature",
				"StatisticsFeature",
			]
		),
		.testTarget(name: "PlaysListFeatureTests", dependencies: ["PlaysListFeature", "SharedModelsLibraryMocks"]),
		.target(
			name: "RecordPlayFeature",
			dependencies: [
				"AnalysisFeature",
				"PlayDetailsFeature",
				"PlaysDataProviderInterface",
			]
		),
		.testTarget(name: "RecordPlayFeatureTests", dependencies: ["RecordPlayFeature"]),
		.target(
			name: "StatisticsFeature",
			dependencies: [
				"StatisticsDataProviderInterface",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(name: "StatisticsFeatureTests", dependencies: ["StatisticsFeature", "SharedModelsLibraryMocks"]),
		.target(
			name: "SolutionsListFeature",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(name: "SolutionsListFeatureTests", dependencies: ["SolutionsListFeature"]),

		// MARK: - Data Providers
		.target(
			name: "PlaysDataProvider",
			dependencies: [
				"PersistenceServiceInterface",
				"PersistentModelsLibrary",
				"PlaysDataProviderInterface",
			]
		),
		.testTarget(name: "PlaysDataProviderTests", dependencies: ["PlaysDataProvider"]),
		.target(
			name: "PlaysDataProviderInterface",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "Dependencies", package: "swift-composable-architecture"),
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
		.testTarget(name: "StatisticsDataProviderTests", dependencies: ["StatisticsDataProvider"]),
		.target(
			name: "StatisticsDataProviderInterface",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "Dependencies", package: "swift-composable-architecture"),
			]
		),

		// MARK: - Services
		.target(
			name: "PersistenceService",
			dependencies: [
				"PersistentModelsLibrary",
				"PersistenceServiceInterface",
			]
		),
		.target(
			name: "PersistenceServiceInterface",
			dependencies: [
				.product(name: "GRDB", package: "grdb.swift"),
				.product(name: "Dependencies", package: "swift-composable-architecture"),
			]
		),
		.testTarget(name: "PersistenceServiceTests", dependencies: ["PersistenceService"]),
		.target(
			name: "SolverService",
			dependencies: [
				"SolverServiceInterface",
				"ValidatorServiceInterface",
			]
		),
		.target(
			name: "SolverServiceInterface",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "Dependencies", package: "swift-composable-architecture"),
			]
		),
		.testTarget(name: "SolverServiceTests", dependencies: ["SolverService"]),
		.target(name: "ValidatorService", dependencies: ["ValidatorServiceInterface"]),
		.testTarget(name: "ValidatorServiceTests", dependencies: ["ValidatorService"]),
		.target(
			name: "ValidatorServiceInterface",
			dependencies: [
				"DictionaryLibrary",
				"SharedModelsLibrary",
				.product(name: "Dependencies", package: "swift-composable-architecture"),
			]),

		// MARK: - Libraries
		.target(name: "DictionaryLibrary", dependencies: []),
		.testTarget(name: "DictionaryLibraryTests", dependencies: ["DictionaryLibrary"]),
		.target(name: "ExtensionsLibrary", dependencies: []),
		.testTarget(name: "ExtensionsLibraryTests", dependencies: ["ExtensionsLibrary"]),
		.target(
			name: "PersistentModelsLibrary",
			dependencies: [
				"SharedModelsLibrary",
				.product(name: "GRDB", package: "grdb.swift"),
			]
		),
		.target(name: "SharedModelsLibrary", dependencies: ["ExtensionsLibrary"]),
		.target(name: "SharedModelsLibraryMocks", dependencies: ["SharedModelsLibrary"]),
		.testTarget(name: "SharedModelsLibraryTests", dependencies: ["SharedModelsLibrary", "SharedModelsLibraryMocks"]),
	]
)
