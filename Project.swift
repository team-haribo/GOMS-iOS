import ProjectDescription

// MARK: Constants
let projectName = "GOMS-iOS"
let organizationName = "HARIBO"
let bundleID = "Minjae.GOMS-iOS"
let targetVersion = "15.0"

// MARK: Struct
let project = Project(
  name: projectName,
  organizationName: organizationName,
  packages: [
    .remote(
        url: "https://github.com/RxSwiftCommunity/RxFlow.git",
        requirement: .upToNextMajor(from: "2.10.0")
    ),
    .remote(
        url: "https://github.com/ReactiveX/RxSwift.git",
        requirement: .upToNextMajor(from: "6.6.0")
    ),
    .remote(
        url: "https://github.com/SnapKit/SnapKit.git",
        requirement: .upToNextMajor(from: "5.0.1")
    ),
    .remote(
        url: "https://github.com/devxoul/Then",
        requirement: .upToNextMajor(from: "2")
    ),
    .remote(
        url: "https://github.com/Moya/Moya.git",
        requirement: .upToNextMajor(from: "15.0.0")
    ),
    .remote(
        url: "https://github.com/onevcat/Kingfisher.git",
        requirement: .upToNextMajor(from: "7.0.0")
    ),
    .remote(
        url: "https://github.com/yannickl/QRCodeReader.swift.git",
        requirement: .upToNextMajor(from: "10.1.0")
    ),
    .remote(
        url: "https://github.com/GSM-MSG/GAuthSignin-Swift",
        requirement: .upToNextMajor(from: "0.0.3")
    ),
    .remote(
        url: "https://github.com/ArtSabintsev/Siren.git",
        requirement: .upToNextMajor(from: "6.1.2")
    ),
    .remote(
        url: "https://github.com/ReactorKit/ReactorKit.git",
        requirement: .upToNextMajor(from: "3.2.0")
    )
  ],
  settings: nil,
  targets: [
    Target(name: projectName,
           platform: .iOS,
           product: .app, // unitTests, .appExtension, .framework, dynamicLibrary, staticFramework
           bundleId: bundleID,
           deploymentTarget: .iOS(
            targetVersion: targetVersion,
            devices: [.iphone, .ipad]
           ),
           infoPlist: .file(path: "\(projectName)/Info.plist"),
           sources: ["\(projectName)/**"],
           resources: ["\(projectName)/Resources/**"],
           dependencies: [
            .package(product: "RxFlow"),
            .package(product: "RxSwift"),
            .package(product: "RxCocoa"),
            .package(product: "SnapKit"),
            .package(product: "Then"),
            .package(product: "Moya"),
            .package(product: "Kingfisher"),
            .package(product: "QRCodeReader"),
            .package(product: "GAuthSignin"),
            .package(product: "Siren"),
            .package(product: "ReactorKit")
           ] // tuist generate할 경우 pod install이 자동으로 실행
          )
  ],
  schemes: [
    Scheme(name: "\(projectName)-Debug"),
    Scheme(name: "\(projectName)-Release")
  ],
  fileHeaderTemplate: nil,
  additionalFiles: [],
  resourceSynthesizers: []
)
