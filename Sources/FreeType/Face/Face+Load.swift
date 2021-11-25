//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

extension Face {
/**************************************************************************
 *
 * @function:
 *   FT_Load_Char
 *
 * @description:
 *   Load a glyph into the glyph slot of a face object, accessed by its
 *   character code.
 *
 * @inout:
 *   face ::
 *     A handle to a target face object where the glyph is loaded.
 *
 * @input:
 *   char_code ::
 *     The glyph's character code, according to the current charmap used in
 *     the face.
 *
 *   load_flags ::
 *     A flag indicating what to load for this glyph.  The @FT_LOAD_XXX
 *     constants can be used to control the glyph loading process (e.g.,
 *     whether the outline should be scaled, whether to load bitmaps or
 *     not, whether to hint the outline, etc).
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   This function simply calls @FT_Get_Char_Index and @FT_Load_Glyph.
 *
 *   Many fonts contain glyphs that can't be loaded by this function since
 *   its glyph indices are not listed in any of the font's charmaps.
 *
 *   If no active cmap is set up (i.e., `face->charmap` is zero), the call
 *   to @FT_Get_Char_Index is omitted, and the function behaves identically
 *   to @FT_Load_Glyph.
 */
//public func FT_Load_Char(_ face: FT_Face!, _ char_code: FT_ULong, _ load_flags: FT_Int32) -> FT_Error
    public func loadChar(unicode: UnicodeScalar, flag: LoadFlag) throws -> Glyph {
        return try self.loadChar(charCode: FT_ULong(unicode.value), flag: flag)
    }
    
    public func loadChar(charCode: FT_ULong, flag: LoadFlag) throws -> Glyph {
        let error = FT_Load_Char(raw, charCode, flag.rawValue)
        if error != 0 {
            throw FreeTypeError.error(code: error)
        }
        return Glyph.from(slot: self.glyph)
    }
    
    public func loadChar2(unicode: UnicodeScalar, flag: LoadFlag) throws -> Bitmap {
        return try self.loadChar2(charCode: FT_ULong(unicode.value), flag: flag)
    }
    
    public func loadChar2(charCode: FT_ULong, flag: LoadFlag) throws -> Bitmap {
        let error = FT_Load_Char(raw, charCode, flag.rawValue)
        if error != 0 {
            throw FreeTypeError.error(code: error)
        }
        return .init(self.glyph)
    }
    

    
    /**************************************************************************
     *
     * @function:
     *   FT_Load_Glyph
     *
     * @description:
     *   Load a glyph into the glyph slot of a face object.
     *
     * @inout:
     *   face ::
     *     A handle to the target face object where the glyph is loaded.
     *
     * @input:
     *   glyph_index ::
     *     The index of the glyph in the font file.  For CID-keyed fonts
     *     (either in PS or in CFF format) this argument specifies the CID
     *     value.
     *
     *   load_flags ::
     *     A flag indicating what to load for this glyph.  The @FT_LOAD_XXX
     *     constants can be used to control the glyph loading process (e.g.,
     *     whether the outline should be scaled, whether to load bitmaps or
     *     not, whether to hint the outline, etc).
     *
     * @return:
     *   FreeType error code.  0~means success.
     *
     * @note:
     *   The loaded glyph may be transformed.  See @FT_Set_Transform for the
     *   details.
     *
     *   For subsetted CID-keyed fonts, `FT_Err_Invalid_Argument` is returned
     *   for invalid CID values (this is, for CID values that don't have a
     *   corresponding glyph in the font).  See the discussion of the
     *   @FT_FACE_FLAG_CID_KEYED flag for more details.
     *
     *   If you receive `FT_Err_Glyph_Too_Big`, try getting the glyph outline
     *   at EM size, then scale it manually and fill it as a graphics
     *   operation.
     */
    //public func FT_Load_Glyph(_ face: FT_Face!, _ glyph_index: FT_UInt, _ load_flags: FT_Int32) -> FT_Error
}

