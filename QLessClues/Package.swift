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
		.library(name: "DictionaryService", targets: ["DictionaryService"]),
		.library(name: "DictionaryServiceInterface", targets: ["DictionaryServiceInterface"]),
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
		.library(name: "SharedModelsMocksLibrary", targets: ["SharedModelsMocksLibrary"]),
		.library(name: "ViewsLibrary", targets: ["ViewsLibrary"]),
	],
	dependencies: [
		.package(url: "https://github.com/groue/GRDB.swift.git", from: "6.27.0"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.2"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.2.2"),
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
				"SharedModelsMocksLibrary",
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
				"SharedModelsMocksLibrary",
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
				"SharedModelsMocksLibrary",
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
				"SharedModelsMocksLibrary",
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
				"SharedModelsMocksLibrary",
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
				"SharedModelsMocksLibrary",
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
				"SharedModelsMocksLibrary",
				"SolutionsListFeature",
			]
		),
		.target(
			name: "StatisticsFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"StatisticsRepositoryInterface",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "StatisticsFeatureTests",
			dependencies: [
				"SharedModelsMocksLibrary",
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
				.product(name: "Dependencies", package: "swift-dependencies"),
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
				.product(name: "Dependencies", package: "swift-dependencies"),
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
			name: "DictionaryService",
			dependencies: [
				"DictionaryServiceInterface",
			]
		),
		.target(
			name: "DictionaryServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				"DictionaryLibrary",
			]
		),
		.testTarget(
			name: "DictionaryServiceTests",
			dependencies: [
				"DictionaryService",
			]
		),
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
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
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
				"DictionaryServiceInterface",
				"SolverServiceInterface",
				"ValidatorServiceInterface",
			]
		),
		.target(
			name: "SolverServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
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
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
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
				"SharedModelsMocksLibrary",
			]
		),
		.target(
			name: "SharedModelsMocksLibrary",
			dependencies: [
				"SharedModelsLibrary",
			]
		),
		.target(
			name: "ViewsLibrary",
			dependencies: []
		),
	]
)
