//
//  Bitmap.swift
//  Test
//
//  Created by Yume on 2021/11/22.
//

import Foundation
import CFreeType

/// rows: 2
/// width: 3
/// pitch: 4
/// 
/// xxx00000 00000000 00000000 00000000
/// xxx00000 00000000 00000000 00000000
public final class Bitmap: CustomStringConvertible {
//    let width: Int
//    let height: Int
    let raw: FT_Bitmap
    
    init(_ glyph: FT_GlyphSlot) {
        self.raw = glyph.pointee.bitmap
    }
    init(_ raw: FT_Bitmap) {
        self.raw = raw
    }
    
    var mapDimension1: [UInt8] {
        let size = Int(raw.rows) * Int(raw.pitch)
        let buffer = UnsafeMutableBufferPointer(start: raw.buffer, count: size)
        return [UInt8](Data(buffer))
    }
    
    var mapDimension2: [ArraySlice<UInt8>] {
        var result: [ArraySlice<UInt8>] = []
        let pitch = Int(raw.pitch)
        let rows = Int(raw.rows)
        for h in 0..<rows {
            let start = 0 + pitch*h
            let end = pitch + pitch*h
            let slice = mapDimension1[start..<end]
            result.append(slice)
        }
        return result
    }
    
    public func show(bit1: String = "\u{25A0}", bit0: String = " ") -> String {
        return mapDimension2.map { slice in
            slice.map { ui8 in
                let result = String(ui8, radix: 2, uppercase: false)
                let pad = [String].init(repeating: "0", count: 8 - result.count).joined(separator: "")
                return pad + result
            }.joined(separator: "")
        }
        .joined(separator: "\n")
        .replacingOccurrences(of: "1", with: bit1)
        .replacingOccurrences(of: "0", with: bit0)
    }
    
    public var description: String {
        return """
        \(raw)
        """
    }
}
