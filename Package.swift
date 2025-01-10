// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "TracePointKit",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "TracePointKit",
      targets: ["TracePointKit"]
    ),
    .library(
      name: "TracePointKitImp",
      targets: ["TracePointKitImp"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "TracePointKit",
      dependencies: [],
      path: "Sources/TracePointKit/interfaces/src"
    ),
    .target(
      name: "TracePointKitImp",
      dependencies: ["TracePointKit"],
      path: "Sources/TracePointKit/implementation/src"
    ),
    .target(
      name: "TracePointKitMock",
      dependencies: ["TracePointKit"],
      path: "Sources/TracePointKit/mocks/src"
    ),
    .testTarget(
      name: "TracePointKitImpTests",
      dependencies: [
        "TracePointKitImp",
        "TracePointKitMock"
      ],
      path: "Sources/TracePointKit/implementation/Tests"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
