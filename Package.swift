// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "iosmodularkits",
  platforms: [.iOS(.v14)],
  products: [
    // AdminPanelKit, AdminPanelKitImp, AdminPanelKitMock
    .library(
        name: "AdminPanelKit",
        targets: ["AdminPanelKit"]
    ),
    .library(
      name: "AdminPanelKitImp",
      targets: ["AdminPanelKitImp"]
    ),
    .library(
      name: "AdminPanelKitMock",
      targets: ["AdminPanelKitMock"]
    ),
    // CommonSharedKit, CommonSharedKitMock
    .library(
      name: "CommonSharedKit",
      targets: ["CommonSharedKit"]
    ),
    .library(
      name: "CommonSharedKitMock",
      targets: ["CommonSharedKitMock"]
    ),
    // ExperimentKit, ExperimentKitImp, ExperimentKitMock
    .library(
      name: "ExperimentKit",
      targets: ["ExperimentKit"]
    ),
    .library(
      name: "ExperimentKitImp",
      targets: ["ExperimentKitImp"]
    ),
    .library(
      name: "ExperimentKitMock",
      targets: ["ExperimentKitMock"]
    ),
    // PersistentStoreKit, PersistentStoreKitImp
    .library(
      name: "PersistentStoreKit",
      targets: ["PersistentStoreKit"]
    ),
    .library(
      name: "PersistentStoreKitImp",
      targets: ["PersistentStoreKitImp"]
    ),
    // InAppMessagingKit, InAppMessagingKitImp, InAppMessagingKitMock
    .library(
      name: "InAppMessagingKit",
      targets: ["InAppMessagingKit"]
    ),
    .library(
      name: "InAppMessagingKitImp",
      targets: ["InAppMessagingKitImp"]
    ),
    .library(
      name: "InAppMessagingKitMock",
      targets: ["InAppMessagingKitMock"]
    ),
    // FlowTrackerKit, FlowTrackerKitImp
    .library(
      name: "FlowTrackerKit",
      targets: ["FlowTrackerKit"]
    ),
    .library(
      name: "FlowTrackerKitImp",
      targets: ["FlowTrackerKitImp"]
    ),
    // PerformanceTrackerKit
    .library(
      name: "PerformanceTrackerKit",
      targets: ["PerformanceTrackerKit"]
    ),
    // LogTrackKit, LogTrackKitImp
    .library(
      name: "LogTrackKit",
      targets: ["LogTrackKit"]
    ),
    .library(
      name: "LogTrackKitImp",
      targets: ["LogTrackKitImp"]
    ),
    // StreamLogDataKit, StreamLogDataKitImp
    .library(
      name: "StreamLogDataKit",
      targets: ["StreamLogDataKit"]
    ),
    .library(
      name: "StreamLogDataKitImp",
      targets: ["StreamLogDataKitImp"]
    ),
  ],
  dependencies: [
    // ExperimentKit
    .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMinor(from: "10.29.0")),
    
    // InAppMessagingKit
    .package(url: "https://github.com/pubnub/swift.git", .upToNextMinor(from: "7.3.1")),
    
    // PersistentStoreKit
    .package(url: "https://github.com/realm/realm-swift.git", .upToNextMinor(from: "10.52.1")),
    
    // StreamLogDataKit
    .package(url: "https://github.com/GuanceCloud/datakit-ios.git", .upToNextMinor(from: "1.5.2")),
  ],
  targets: [
    // AdminPanelKit, AdminPanelKitImp, AdminPanelKitMock, AdminPanelKitImpTests
    .target(
      name: "AdminPanelKit",
      dependencies: ["ExperimentKit"],
      path: "Sources/AdminPanelKit/interfaces/src"
    ),
    .target(
      name: "AdminPanelKitImp",
      dependencies: [
        "AdminPanelKit",
        "ExperimentKit"
      ],
      path: "Sources/AdminPanelKit/implementation/src"
    ),
    .target(
      name: "AdminPanelKitMock",
      dependencies: ["AdminPanelKit"],
      path: "Sources/AdminPanelKit/mocks/src"
    ),
    .testTarget(
      name: "AdminPanelKitImpTests",
      dependencies: [
        "AdminPanelKitImp",
        "AdminPanelKitMock",
      ],
      path: "Sources/AdminPanelKit/implementation/Tests"
    ),
    // CommonSharedKit, CommonSharedKitMock
    .target(
      name: "CommonSharedKit",
      dependencies: [],
      path: "Sources/CommonSharedKit/interfaces/src"
    ),
    .target(
      name: "CommonSharedKitMock",
      dependencies: ["CommonSharedKit"],
      path: "Sources/CommonSharedKit/mocks/src"
    ),
    // ExperimentKit, ExperimentKitImp, ExperimentKitMock, ExperimentKitImpTests
    .target(
      name: "ExperimentKit",
      dependencies: [],
      path: "Sources/ExperimentKit/interfaces/src"
    ),
    .target(
      name: "ExperimentKitImp",
      dependencies: [
        "LogTrackKit",
        "ExperimentKit",
        "CommonSharedKit",
        .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
      ],
      path: "Sources/ExperimentKit/implementation/src"
    ),
    .target(
      name: "ExperimentKitMock",
      dependencies: ["ExperimentKit"],
      path: "Sources/ExperimentKit/mocks/src"
    ),
    .testTarget(
      name: "ExperimentKitImpTests",
      dependencies: [
        "ExperimentKitImp",
        "ExperimentKitMock",
        "LogTrackKitMock",
      ],
      path: "Sources/ExperimentKit/implementation/Tests"
    ),
    // PersistentStoreKit, PersistentStoreKitImp, PersistentStoreKitMock, PersistentStoreKitImpTests
    .target(
      name: "PersistentStoreKit",
      dependencies: [],
      path: "Sources/PersistentStoreKit/interfaces/src"
    ),
    .target(
      name: "PersistentStoreKitImp",
      dependencies: [
        "PersistentStoreKit",
        "LogTrackKit",
        "CommonSharedKit",
        .product(name: "RealmSwift", package: "realm-swift")
      ],
      path: "Sources/PersistentStoreKit/implementation/src"
    ),
    .target(
      name: "PersistentStoreKitMock",
      dependencies: ["PersistentStoreKit"],
      path: "Sources/PersistentStoreKit/mocks/src"
    ),
    .testTarget(
      name: "PersistentStoreKitImpTests",
      dependencies: [
        "PersistentStoreKitImp",
        "PersistentStoreKitMock",
        "LogTrackKitMock",
        "CommonSharedKitMock",
      ],
      path: "Sources/PersistentStoreKit/implementation/Tests"
    ),
    // InAppMessagingKit, InAppMessagingKitImp, InAppMessagingKitMock, InAppMessagingKitImpTests
    .target(
      name: "InAppMessagingKit",
      dependencies: [],
      path: "Sources/InAppMessagingKit/interfaces/src"
    ),
    .target(
      name: "InAppMessagingKitImp",
      dependencies: [
        "InAppMessagingKit",
        "CommonSharedKit",
        "LogTrackKit",
        .product(name: "PubNub", package: "swift")
      ],
      path: "Sources/InAppMessagingKit/implementation/src"
    ),
    .target(
      name: "InAppMessagingKitMock",
      dependencies: [
        "InAppMessagingKit"
      ],
      path: "Sources/InAppMessagingKit/mocks/src"
    ),
    .testTarget(
      name: "InAppMessagingKitImpTests",
      dependencies: [
        "InAppMessagingKitImp",
        "InAppMessagingKitMock",
        "PersistentStoreKitMock",
        "LogTrackKitMock",
        "CommonSharedKitMock",
      ],
      path: "Sources/InAppMessagingKit/implementation/Tests"
    ),
    // FlowTrackerKit, FlowTrackerKitImp, FlowTrackerKitMock, FlowTrackerKitImpTests
    .target(
      name: "FlowTrackerKit",
      dependencies: [],
      path: "Sources/FlowTrackerKit/interfaces/src"
    ),
    .target(
      name: "FlowTrackerKitImp",
      dependencies: [
        "FlowTrackerKit",
        "CommonSharedKit",
        "LogTrackKit"
      ],
      path: "Sources/FlowTrackerKit/implementation/src"
    ),
    .target(
      name: "FlowTrackerKitMock",
      dependencies: [
        "FlowTrackerKit"
      ],
      path: "Sources/FlowTrackerKit/mocks/src"
    ),
    .testTarget(
      name: "FlowTrackerKitImpTests",
      dependencies: [
        "FlowTrackerKitImp",
        "FlowTrackerKitMock",
        "CommonSharedKitMock",
        "LogTrackKitMock",
      ],
      path: "Sources/FlowTrackerKit/implementation/Tests"
    ),
    // PerformanceTrackerKit, PerformanceTrackerKitMock
    .target(
      name: "PerformanceTrackerKit",
      dependencies: [
        "LogTrackKit",
        "CommonSharedKit",
      ],
      path: "Sources/PerformanceTrackerKit/interfaces/src"
    ),
    .target(
      name: "PerformanceTrackerKitMock",
      dependencies: [
        "PerformanceTrackerKit"
      ],
      path: "Sources/PerformanceTrackerKit/mocks/src"
    ),
    // StreamLogDataKit, StreamLogDataKitImp, StreamLogDataKitMock, StreamLogDataKitImpTests
    .target(
      name: "StreamLogDataKit",
      dependencies: [],
      path: "Sources/StreamLogDataKit/interfaces/src"
    ),
    .target(
      name: "StreamLogDataKitImp",
      dependencies: [
        "StreamLogDataKit",
        .product(name: "FTMobileSDK", package: "datakit-ios")
      ],
      path: "Sources/StreamLogDataKit/implementation/src"
    ),
    .target(
      name: "StreamLogDataKitMock",
      dependencies: ["StreamLogDataKit"],
      path: "Sources/StreamLogDataKit/mocks/src"
    ),
    .testTarget(
      name: "StreamLogDataKitImpTests",
      dependencies: [
        "StreamLogDataKitImp",
        "StreamLogDataKitMock",
      ],
      path: "Sources/StreamLogDataKit/implementation/Tests"
    ),
    // LogTrackKit, LogTrackKitImp, LogTrackKitMock, LogTrackKitImpTests
    .target(
      name: "LogTrackKit",
      dependencies: [],
      path: "Sources/LogTrackKit/interfaces/src"
    ),
    .target(
      name: "LogTrackKitImp",
      dependencies: [
        "LogTrackKit",
      ],
      path: "Sources/LogTrackKit/implementation/src"
    ),
    .target(
      name: "LogTrackKitMock",
      dependencies: [
        "LogTrackKit"
      ],
      path: "Sources/LogTrackKit/mocks/src"
    ),
    .testTarget(
      name: "LogTrackKitImpTests",
      dependencies: [
        "LogTrackKitImp",
        "LogTrackKitMock"
      ],
      path: "Sources/LogTrackKit/implementation/Tests"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
