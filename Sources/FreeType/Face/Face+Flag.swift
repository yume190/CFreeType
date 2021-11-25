//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

/**************************************************************************
 *
 * @enum:
 *   FT_FACE_FLAG_XXX
 *
 * @description:
 *   A list of bit flags used in the `face_flags` field of the @FT_FaceRec
 *   structure.  They inform client applications of properties of the
 *   corresponding face.
 *
 * @values:
 *   FT_FACE_FLAG_SCALABLE ::
 *     The face contains outline glyphs.  Note that a face can contain
 *     bitmap strikes also, i.e., a face can have both this flag and
 *     @FT_FACE_FLAG_FIXED_SIZES set.
 *
 *   FT_FACE_FLAG_FIXED_SIZES ::
 *     The face contains bitmap strikes.  See also the `num_fixed_sizes`
 *     and `available_sizes` fields of @FT_FaceRec.
 *
 *   FT_FACE_FLAG_FIXED_WIDTH ::
 *     The face contains fixed-width characters (like Courier, Lucida,
 *     MonoType, etc.).
 *
 *   FT_FACE_FLAG_SFNT ::
 *     The face uses the SFNT storage scheme.  For now, this means TrueType
 *     and OpenType.
 *
 *   FT_FACE_FLAG_HORIZONTAL ::
 *     The face contains horizontal glyph metrics.  This should be set for
 *     all common formats.
 *
 *   FT_FACE_FLAG_VERTICAL ::
 *     The face contains vertical glyph metrics.  This is only available in
 *     some formats, not all of them.
 *
 *   FT_FACE_FLAG_KERNING ::
 *     The face contains kerning information.  If set, the kerning distance
 *     can be retrieved using the function @FT_Get_Kerning.  Otherwise the
 *     function always return the vector (0,0).  Note that FreeType doesn't
 *     handle kerning data from the SFNT 'GPOS' table (as present in many
 *     OpenType fonts).
 *
 *   FT_FACE_FLAG_FAST_GLYPHS ::
 *     THIS FLAG IS DEPRECATED.  DO NOT USE OR TEST IT.
 *
 *   FT_FACE_FLAG_MULTIPLE_MASTERS ::
 *     The face contains multiple masters and is capable of interpolating
 *     between them.  Supported formats are Adobe MM, TrueType GX, and
 *     OpenType variation fonts.
 *
 *     See section @multiple_masters for API details.
 *
 *   FT_FACE_FLAG_GLYPH_NAMES ::
 *     The face contains glyph names, which can be retrieved using
 *     @FT_Get_Glyph_Name.  Note that some TrueType fonts contain broken
 *     glyph name tables.  Use the function @FT_Has_PS_Glyph_Names when
 *     needed.
 *
 *   FT_FACE_FLAG_EXTERNAL_STREAM ::
 *     Used internally by FreeType to indicate that a face's stream was
 *     provided by the client application and should not be destroyed when
 *     @FT_Done_Face is called.  Don't read or test this flag.
 *
 *   FT_FACE_FLAG_HINTER ::
 *     The font driver has a hinting machine of its own.  For example, with
 *     TrueType fonts, it makes sense to use data from the SFNT 'gasp'
 *     table only if the native TrueType hinting engine (with the bytecode
 *     interpreter) is available and active.
 *
 *   FT_FACE_FLAG_CID_KEYED ::
 *     The face is CID-keyed.  In that case, the face is not accessed by
 *     glyph indices but by CID values.  For subsetted CID-keyed fonts this
 *     has the consequence that not all index values are a valid argument
 *     to @FT_Load_Glyph.  Only the CID values for which corresponding
 *     glyphs in the subsetted font exist make `FT_Load_Glyph` return
 *     successfully; in all other cases you get an
 *     `FT_Err_Invalid_Argument` error.
 *
 *     Note that CID-keyed fonts that are in an SFNT wrapper (this is, all
 *     OpenType/CFF fonts) don't have this flag set since the glyphs are
 *     accessed in the normal way (using contiguous indices); the
 *     'CID-ness' isn't visible to the application.
 *
 *   FT_FACE_FLAG_TRICKY ::
 *     The face is 'tricky', this is, it always needs the font format's
 *     native hinting engine to get a reasonable result.  A typical example
 *     is the old Chinese font `mingli.ttf` (but not `mingliu.ttc`) that
 *     uses TrueType bytecode instructions to move and scale all of its
 *     subglyphs.
 *
 *     It is not possible to auto-hint such fonts using
 *     @FT_LOAD_FORCE_AUTOHINT; it will also ignore @FT_LOAD_NO_HINTING.
 *     You have to set both @FT_LOAD_NO_HINTING and @FT_LOAD_NO_AUTOHINT to
 *     really disable hinting; however, you probably never want this except
 *     for demonstration purposes.
 *
 *     Currently, there are about a dozen TrueType fonts in the list of
 *     tricky fonts; they are hard-coded in file `ttobjs.c`.
 *
 *   FT_FACE_FLAG_COLOR ::
 *     [Since 2.5.1] The face has color glyph tables.  See @FT_LOAD_COLOR
 *     for more information.
 *
 *   FT_FACE_FLAG_VARIATION ::
 *     [Since 2.9] Set if the current face (or named instance) has been
 *     altered with @FT_Set_MM_Design_Coordinates,
 *     @FT_Set_Var_Design_Coordinates, or @FT_Set_Var_Blend_Coordinates.
 *     This flag is unset by a call to @FT_Set_Named_Instance.
 */



//#define FT_FACE_FLAG_SCALABLE          ( 1L <<  0 )
//#define FT_FACE_FLAG_FIXED_SIZES       ( 1L <<  1 )
//#define FT_FACE_FLAG_FIXED_WIDTH       ( 1L <<  2 )
//#define FT_FACE_FLAG_SFNT              ( 1L <<  3 )
//#define FT_FACE_FLAG_HORIZONTAL        ( 1L <<  4 )
//#define FT_FACE_FLAG_VERTICAL          ( 1L <<  5 )
//#define FT_FACE_FLAG_KERNING           ( 1L <<  6 )
//#define FT_FACE_FLAG_FAST_GLYPHS       ( 1L <<  7 )
//#define FT_FACE_FLAG_MULTIPLE_MASTERS  ( 1L <<  8 )
//#define FT_FACE_FLAG_GLYPH_NAMES       ( 1L <<  9 )
//#define FT_FACE_FLAG_EXTERNAL_STREAM   ( 1L << 10 )
//#define FT_FACE_FLAG_HINTER            ( 1L << 11 )
//#define FT_FACE_FLAG_CID_KEYED         ( 1L << 12 )
//#define FT_FACE_FLAG_TRICKY            ( 1L << 13 )
//#define FT_FACE_FLAG_COLOR             ( 1L << 14 )
//#define FT_FACE_FLAG_VARIATION         ( 1L << 15 )
struct FaceFlag: RawRepresentable {
    let rawValue: Int
    init?(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    init(_ raw: Int) {
        self.rawValue = raw
    }
    
    static let SCALABLE: FaceFlag = .init(FT_FACE_FLAG_SCALABLE)
    static let FIXED_SIZES: FaceFlag = .init(FT_FACE_FLAG_FIXED_SIZES)
    static let FIXED_WIDTH: FaceFlag = .init(FT_FACE_FLAG_FIXED_WIDTH)
    static let SFNT: FaceFlag = .init(FT_FACE_FLAG_SFNT)
    static let HORIZONTAL: FaceFlag = .init(FT_FACE_FLAG_HORIZONTAL)
    static let VERTICAL: FaceFlag = .init(FT_FACE_FLAG_VERTICAL)
    static let KERNING: FaceFlag = .init(FT_FACE_FLAG_KERNING)
    // THIS FLAG IS DEPRECATED.  DO NOT USE OR TEST IT.
    // static let FAST_GLYPHS: FaceFlag = .init(FT_FACE_FLAG_FAST_GLYPHS)
    static let MULTIPLE_MASTERS: FaceFlag = .init(FT_FACE_FLAG_MULTIPLE_MASTERS)
    static let GLYPH_NAMES: FaceFlag = .init(FT_FACE_FLAG_GLYPH_NAMES)
    static let EXTERNAL_STREAM: FaceFlag = .init(FT_FACE_FLAG_EXTERNAL_STREAM)
    static let HINTER: FaceFlag = .init(FT_FACE_FLAG_HINTER)
    static let CID_KEYED: FaceFlag = .init(FT_FACE_FLAG_CID_KEYED)
    static let TRICKY: FaceFlag = .init(FT_FACE_FLAG_TRICKY)
    static let COLOR: FaceFlag = .init(FT_FACE_FLAG_COLOR)
    static let VARIATION: FaceFlag = .init(FT_FACE_FLAG_VARIATION)
}

extension Face {
    /// #define FT_HAS_HORIZONTAL( face ) \
    ///           ( !!( (face)->face_flags & FT_FACE_FLAG_HORIZONTAL ) )
    fileprivate func isContain(flag: FaceFlag) -> Bool {
        return (self.face_flags & flag.rawValue) != 0
    }
}

public extension Face {
    var hasHorizontal: Bool {
        return isContain(flag: .HORIZONTAL)
    }
    
    var hasVertical: Bool {
        return isContain(flag: .VERTICAL)
    }
    
    var hasKerning: Bool {
        return isContain(flag: .KERNING)
    }
    
    var hasFixedSizes: Bool {
        return isContain(flag: .FIXED_SIZES)
    }
    
    var hasGlyphNames: Bool {
        return isContain(flag: .GLYPH_NAMES)
    }
    
    var hasColor: Bool {
        return isContain(flag: .COLOR)
    }
    
    var hasMultipleMasters: Bool {
        return isContain(flag: .MULTIPLE_MASTERS)
    }
    
    var isSFNT: Bool {
        return isContain(flag: .SFNT)
    }
    
    var isScalable: Bool {
        return isContain(flag: .SCALABLE)
    }
    
    var isFixedWidth: Bool {
        return isContain(flag: .FIXED_WIDTH)
    }
    
    var isCIDKeyed: Bool {
        return isContain(flag: .CID_KEYED)
    }
    
    var isTricky: Bool {
        return isContain(flag: .TRICKY)
    }
    
    var isVariation: Bool {
        return isContain(flag: .VARIATION)
    }
}


//#define FT_IS_NAMED_INSTANCE( face ) \
//          ( !!( (face)->face_index & 0x7FFF0000L ) )
