//
//  Glyph.swift
//  Test
//
//  Created by Yume on 2021/11/22.
//

import Foundation
import CFreeType

public struct Glyph {
    let pixels: [UInt8]
    let size: Size
    
    var map: [ArraySlice<UInt8>] {
        var result: [ArraySlice<UInt8>] = []
        for h in 0..<size.height {
            let start = Int(0 + size.width*h)
            let end = Int(size.width + size.width*h)
            let slice = pixels[start..<end]
            result.append(slice)
        }
        return result
    }
    
    public func show(bit1: String = "\u{25A0}", bit0: String = " ") {
        for slice in map {
            for bit in slice {
                let s = bit == 1 ? bit1 : bit0
                print(s, separator: "", terminator: "")
            }
            print("")
        }
    }
    
    /// Construct and return a Glyph object from a FreeType GlyphSlot.
    static func from(slot: FT_GlyphSlot!) -> Glyph {
        let pixels = unpack_mono_bitmap(slot.pointee.bitmap)
        //    pixels = Glyph.unpack_mono_bitmap(slot.bitmap)
        //    width, height = slot.bitmap.width, slot.bitmap.rows
        return Glyph(pixels: pixels, size: .init(bitmap: slot.pointee.bitmap))
    }
    
    /// Unpack a freetype FT_LOAD_TARGET_MONO glyph bitmap into a bytearray where
    /// each pixel is represented by a single byte.
    static func unpack_mono_bitmap(_ bitmap: FT_Bitmap) -> [UInt8] {
        // Allocate a bytearray of sufficient size to hold the glyph bitmap.
//        var data: [[UInt8]] = .init(repeating: <#T##[UInt8]#>, count: <#T##Int#>)
        var data: [UInt8] = .init(repeating: 0, count: Int(bitmap.rows * bitmap.width))
        
        // Iterate over every byte in the glyph bitmap. Note that we're not
        // iterating over every pixel in the resulting unpacked bitmap --
        // we're iterating over the packed bytes in the input bitmap.
        
//        [UInt8](Data(UnsafeMutableBufferPointer(start: bitmap.buffer, count: data.count)))
        let buffer = UnsafeMutableBufferPointer(start: bitmap.buffer, count: data.count)
        for y in 0..<bitmap.rows {
            for byteIndex in 0..<bitmap.pitch {
                // Read the byte that contains the packed pixel data.
                let byteValue = buffer[Int(y) * Int(bitmap.pitch) + Int(byteIndex)]
                
                // We've processed this many bits (=pixels) so far. This determines
                // where we'll read the next batch of pixels from.
                let numBitsDone = byteIndex * 8
                
                // Pre-compute where to write the pixels that we're going
                // to unpack from the current byte in the glyph bitmap.
                let rowStart = Int(y * bitmap.width) + Int(byteIndex) * 8

                // Iterate over every bit (=pixel) that's still a part of the
                // output bitmap. Sometimes we're only unpacking a fraction of a byte
                // because glyphs may not always fit on a byte boundary. So we make sure
                // to stop if we unpack past the current row of pixels.
                let _min = min(8, Int32(bitmap.width) - numBitsDone)
                if _min < 0 {
                    continue
                }
                for bitIndex in 0..<_min {
                    // Unpack the next pixel from the current glyph byte.
                    let bit = byteValue & (1 << (7 - bitIndex))

                    // Write the pixel to the output bytearray. We ensure that `off`
                    // pixels have a value of 0 and `on` pixels have a value of 1.
//                    1 if bit else 0
                    data[rowStart + Int(bitIndex)] = bit > 0 ? 1 : 0
                }
            }
        }
        return data
    }
}
