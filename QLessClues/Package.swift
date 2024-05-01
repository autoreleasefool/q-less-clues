// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "Approach",
	defaultLocalization: "en",
	platforms: [
		.iOS("17.0"),
	],
	products: [
		// MARK: - Features
		.library(name: "AnalysisFeature", targets: ["AnalysisFeature"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "HintsFeature", targets: ["HintsFeature"]),
		.library(name: "PlayDetailsFeature", targets: ["PlayDetailsFeature"]),
		.library(name: "PlaysListFeature", targets: ["PlaysListFeature"]),
		.library(name: "RecordPlayFeature", targets: ["RecordPlayFeature"]),
		.library(name: "SolutionsListFeature", targets: ["SolutionsListFeature"]),
		.library(name: "StatisticsFeature", targets: ["StatisticsFeature"]),

		// MARK: - Repositories
		.library(name: "PlaysRepository", targets: ["PlaysRepository"]),
		.library(name: "PlaysRepositoryInterface", targets: ["PlaysRepositoryInterface"]),
		.library(name: "StatisticsRepository", targets: ["StatisticsRepository"]),
		.library(name: "StatisticsRepositoryInterface", targets: ["StatisticsRepositoryInterface"]),

		// MARK: - Data Providers

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
	],
	dependencies: [
		.package(url: "https://github.com/groue/GRDB.swift.git", from: "6.21.0"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.43.0"),
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
		.testTarget(
			name: "AnalysisFeatureTests",
			dependencies: [
				"AnalysisFeature",
			]
		),
		.target(
			name: "AppFeature",
			dependencies: [
				"PlaysListFeature",
			]
		),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: [
				"AppFeature",
			]
		),
		.target(
			name: "HintsFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"DictionaryLibrary",
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "HintsFeatureTests",
			dependencies: [
				"HintsFeature",
			]
		),
		.target(
			name: "PlayDetailsFeature",
			dependencies: [
				"AnalysisFeature",
				"PlaysRepositoryInterface",
			]
		),
		.testTarget(
			name: "PlayDetailsFeatureTests",
			dependencies: [
				"PlayDetailsFeature",
			]
		),
		.target(
			name: "PlaysListFeature",
			dependencies: [
				"RecordPlayFeature",
				"StatisticsFeature",
			]
		),
		.testTarget(
			name: "PlaysListFeatureTests",
			dependencies: [
				"PlaysListFeature",
			]
		),
		.target(
			name: "RecordPlayFeature",
			dependencies: [
				"PlayDetailsFeature",
			]
		),
		.testTarget(
			name: "RecordPlayFeatureTests",
			dependencies: [
				"RecordPlayFeature",
			]
		),
		.target(
			name: "SolutionsListFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "SolutionsListFeatureTests",
			dependencies: [
				"SolutionsListFeature",
			]
		),
		.target(
			name: "StatisticsFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"StatisticsRepositoryInterface",
			]
		),
		.testTarget(
			name: "StatisticsFeatureTests",
			dependencies: [
				"StatisticsFeature",
			]
		),

		// MARK: - Repositories
		.target(
			name: "PlaysRepository",
			dependencies: [
				"PersistenceServiceInterface",
				"PersistentModelsLibrary",
				"PlaysRepositoryInterface",
			]
		),
		.target(
			name: "PlaysRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-composable-architecture"),
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "PlaysRepositoryTests",
			dependencies: [
				"PlaysRepository",
			]
		),
		.target(
			name: "StatisticsRepository",
			dependencies: [
				"PersistenceServiceInterface",
				"PersistentModelsLibrary",
				"StatisticsRepositoryInterface",
			]
		),
		.target(
			name: "StatisticsRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-composable-architecture"),
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "StatisticsRepositoryTests",
			dependencies: [
				"StatisticsRepository",
			]
		),

		// MARK: - Data Providers

		// MARK: - Services
		.target(
			name: "PersistenceService",
			dependencies: [
				"PersistenceServiceInterface",
				"PersistentModelsLibrary",
			]
		),
		.target(
			name: "PersistenceServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-composable-architecture"),
				.product(name: "GRDB", package: "GRDB.swift"),
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "PersistenceServiceTests",
			dependencies: [
				"PersistenceService",
			]
		),
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
				.product(name: "Dependencies", package: "swift-composable-architecture"),
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "SolverServiceTests",
			dependencies: [
				"SolverService",
			]
		),
		.target(
			name: "ValidatorService",
			dependencies: [
				"ValidatorServiceInterface",
			]
		),
		.target(
			name: "ValidatorServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-composable-architecture"),
				"DictionaryLibrary",
				"SharedModelsLibrary",
			]
		),
		.testTarget(
			name: "ValidatorServiceTests",
			dependencies: [
				"ValidatorService",
			]
		),

		// MARK: - Libraries
		.target(
			name: "DictionaryLibrary",
			dependencies: []
		),
		.testTarget(
			name: "DictionaryLibraryTests",
			dependencies: [
				"DictionaryLibrary",
			]
		),
		.target(
			name: "ExtensionsLibrary",
			dependencies: []
		),
		.testTarget(
			name: "ExtensionsLibraryTests",
			dependencies: [
				"ExtensionsLibrary",
			]
		),
		.target(
			name: "PersistentModelsLibrary",
			dependencies: [
				.product(name: "GRDB", package: "GRDB.swift"),
				"SharedModelsLibrary",
			]
		),
		.target(
			name: "SharedModelsLibrary",
			dependencies: [
				"ExtensionsLibrary",
			]
		),
		.testTarget(
			name: "SharedModelsLibraryTests",
			dependencies: [
				"SharedModelsLibrary",
			]
		),
	]
)
