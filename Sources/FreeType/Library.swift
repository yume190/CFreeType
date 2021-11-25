//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

public final class Library {
    let raw: FT_Library
    public init() throws {
        var lib: FT_Library? = nil
        let err = FT_Init_FreeType(&lib)
        if err != 0 {
            throw FreeTypeError.error(code: err)
        }
        guard let _lib = lib else {
            throw FreeTypeError.initFail
        }
        self.raw = _lib
    }
    
    deinit {
        FT_Done_FreeType(raw)
    }
    
    public var version: String {
        var major: FT_Int = 0
        var minor: FT_Int = 0
        var patch: FT_Int = 0
        FT_Library_Version(raw, &major, &minor, &patch)
        return "\(major).\(minor).\(patch)"
    }
    
    public var major: Int32 {
        return FREETYPE_MAJOR
    }
    
    public var minor: Int32 {
        return FREETYPE_MINOR
    }
    
    public var patch: Int32 {
        return FREETYPE_PATCH
    }
}
