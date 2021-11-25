//
//  File.swift
//  
//
//  Created by Yume on 2021/11/25.
//

import Foundation
import ArgumentParser
import FreeType

struct Command: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        commandName: "bitmap",
        abstract: "",
        discussion: """
        
        """,
        version: "0.0.1"
    )
    
    @Option(name: [.customLong("fontPath", withSingleDash: false), .short], help: "font path")
    var fontPath: String
    
    @Option(name: [.customLong("text", withSingleDash: false), .short], help: "text to bitmap")
    var text: String = "你好 Hello"
    
    @Option(name: [.customLong("size", withSingleDash: false), .short], help: "bitmap size")
    var size: UInt32 = 24
    
    func run() throws {
        let path = URL(fileURLWithPath: fontPath).path
        guard FileManager.default.fileExists(atPath: path) else {
            print("can't find font at `\(path)`")
            return
        }
        
        let library = try Library()
        let faceMemory = try Face.file(library: library, path: path)
        try faceMemory.setPixelSizes(size: .init(size))
        
        for unicode in text.unicodeScalars {
            let bitmap = try faceMemory.loadChar2(unicode: unicode, flag: [.RENDER, .TARGET_MONO])
            print(bitmap.show())
        }
    }
}

Command.main()
