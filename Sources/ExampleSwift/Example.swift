//
//  File.swift
//  
//
//  Created by Yume on 2021/11/23.
//

import Foundation
import FreeType

let text = "ABCabc新年快樂こんにちは".unicodeScalars
@main
struct Main {
    static func main() throws {
        let ttf = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
////        let ttf = "/System/Library/Fonts/Supplemental/Apple Chancery.ttf"
        
        let lib = try Library()
        let file = try Face.file(library: lib, path: ttf)
        try file.setPixelSizes(size: .init(20))
        let mem = try Face.memory(library: lib, path: ttf)
        try mem.setPixelSizes(size: .init(20))
        
//        try self.test(mem)
        print(ttf)
        self.showFaceInfo(mem)
//        try self.showAllGlyph(mem)

//        try mem.loadChar(charCode: 35, flag: [.RENDER, .TARGET_MONO]).show()
//        try print(mem.loadChar2(charCode: 35, flag: [.RENDER, .TARGET_MONO]).show())

        print(lib.version)
    }
    
    static func test(_ face: Face) throws {
        for unicode in text {
            print("\(unicode) \(face.getCharIndex(unicode: unicode))")
            try face.loadChar(unicode: unicode, flag: [.RENDER, .TARGET_MONO]).show()
        }
        print(face.getNameIndex(glyphName: "A"))
        print(face.getNameIndex(glyphName: "新"))
        print(face.getNameIndex(glyphName: "こ"))
    }
    
    static func showFaceInfo(_ face: Face) {
        print(face)
    }
    
    static func showAllGlyph(_ face: Face) throws {
        var (index, charCode) = face.getFirstChar()
        
        while index != 0 {
            (index, charCode) = face.getNextChar(charCode: charCode)
//            if charCode == 32 {
//                continue
//            }
            
            print("\(charCode) \(face.getCharIndex(charCode: charCode))")
//            try face.loadChar(charCode: charCode, flag: [.RENDER, .TARGET_MONO]).show()
//            print("-----------------")
            let bitmap = try face.loadChar2(charCode: charCode, flag: [.RENDER, .TARGET_MONO])
            
            print(bitmap.show())
            print(bitmap)
            usleep(100_000)
//            print("\u{001B}[2J")
            print("")
        }
    }
    
}
//static func unpack_mono_bitmap(_ bitmap: FT_Bitmap) -> [UInt8] {
//    // Allocate a bytearray of sufficient size to hold the glyph bitmap.
////        var data: [[UInt8]] = .init(repeating: <#T##[UInt8]#>, count: <#T##Int#>)
//    var data: [UInt8] = .init(repeating: 0, count: Int(bitmap.rows * bitmap.width))
