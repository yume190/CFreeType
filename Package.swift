// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
//-DFT2_BUILD_LIBRARY

let package = Package(
    name: "CFreeType",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FreeType",
            targets: ["FreeType"]),
        /// source https://yycking.pixnet.net/blog/post/154177252
        // .executable(name: "ExampleC", targets: ["ExampleC"])
         .executable(name: "exampleSwift", targets: ["ExampleSwift"])
        .executable(name: "bitmap", targets: ["Bitmap"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.0.2")),
    ],
    targets: [
        .executableTarget(
            name: "Bitmap",
            dependencies: [
                "FreeType",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .executableTarget(
            name: "ExampleSwift",
            dependencies: [
                "FreeType",
            ],
            cSettings:[
//                .unsafeFlags(["-DFT_FREETYPE_H"], nil)
            ]
        ),
        
        // .target(
        //     name: "ExampleC",
        //     dependencies: [
        //         "CFreeType"
        //     ]
        // ),
        .target(
            name: "FreeType",
            dependencies: [
                "CFreeType"
            ]
        ),
        
        /// /usr/local/lib/pkgconfig/freetype2.pc
        .systemLibrary(
            name: "CFreeType",
            pkgConfig: "freetype2",
            providers: [
                .brew(["freetype"])
            ]
        )
    ]
)
