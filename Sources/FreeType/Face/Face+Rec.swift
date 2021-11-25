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
 * @struct:
 *   FT_FaceRec
 *
 * @description:
 *   FreeType root face class structure.  A face object models a typeface
 *   in a font file.
 *
 * @fields:
 
 *

 *
 *   num_fixed_sizes ::
 *     The number of bitmap strikes in the face.  Even if the face is
 *     scalable, there might still be bitmap strikes, which are called
 *     'sbits' in that case.
 *
 *   available_sizes ::
 *     An array of @FT_Bitmap_Size for all bitmap strikes in the face.  It
 *     is set to `NULL` if there is no bitmap strike.
 *
 *     Note that FreeType tries to sanitize the strike data since they are
 *     sometimes sloppy or incorrect, but this can easily fail.
 *
 *   num_charmaps ::
 *     The number of charmaps in the face.
 *
 *   charmaps ::
 *     An array of the charmaps of the face.
 *
 *   generic ::
 *     A field reserved for client uses.  See the @FT_Generic type
 *     description.
 *
 *   bbox ::
 *     The font bounding box.  Coordinates are expressed in font units (see
 *     `units_per_EM`).  The box is large enough to contain any glyph from
 *     the font.  Thus, `bbox.yMax` can be seen as the 'maximum ascender',
 *     and `bbox.yMin` as the 'minimum descender'.  Only relevant for
 *     scalable formats.
 *
 *     Note that the bounding box might be off by (at least) one pixel for
 *     hinted fonts.  See @FT_Size_Metrics for further discussion.
 *
 *     Note that the bounding box does not vary in OpenType variable fonts
 *     and should only be used in relation to the default instance.
 *
 *   units_per_EM ::
 *     The number of font units per EM square for this face.  This is
 *     typically 2048 for TrueType fonts, and 1000 for Type~1 fonts.  Only
 *     relevant for scalable formats.
 *
 *   ascender ::
 *     The typographic ascender of the face, expressed in font units.  For
 *     font formats not having this information, it is set to `bbox.yMax`.
 *     Only relevant for scalable formats.
 *
 *   descender ::
 *     The typographic descender of the face, expressed in font units.  For
 *     font formats not having this information, it is set to `bbox.yMin`.
 *     Note that this field is negative for values below the baseline.
 *     Only relevant for scalable formats.
 *
 *   height ::
 *     This value is the vertical distance between two consecutive
 *     baselines, expressed in font units.  It is always positive.  Only
 *     relevant for scalable formats.
 *
 *     If you want the global glyph height, use `ascender - descender`.
 *
 *   max_advance_width ::
 *     The maximum advance width, in font units, for all glyphs in this
 *     face.  This can be used to make word wrapping computations faster.
 *     Only relevant for scalable formats.
 *
 *   max_advance_height ::
 *     The maximum advance height, in font units, for all glyphs in this
 *     face.  This is only relevant for vertical layouts, and is set to
 *     `height` for fonts that do not provide vertical metrics.  Only
 *     relevant for scalable formats.
 *
 *   underline_position ::
 *     The position, in font units, of the underline line for this face.
 *     It is the center of the underlining stem.  Only relevant for
 *     scalable formats.
 *
 *   underline_thickness ::
 *     The thickness, in font units, of the underline for this face.  Only
 *     relevant for scalable formats.
 *
 *   glyph ::
 *     The face's associated glyph slot(s).
 *
 *   size ::
 *     The current active size for this face.
 *
 *   charmap ::
 *     The current active charmap for this face.
 *
 * @note:
 *   Fields may be changed after a call to @FT_Attach_File or
 *   @FT_Attach_Stream.
 *
 *   For an OpenType variation font, the values of the following fields can
 *   change after a call to @FT_Set_Var_Design_Coordinates (and friends) if
 *   the font contains an 'MVAR' table: `ascender`, `descender`, `height`,
 *   `underline_position`, and `underline_thickness`.
 *
 *   Especially for TrueType fonts see also the documentation for
 *   @FT_Size_Metrics.
 */
extension Face {
    /// num_faces ::
    ///   The number of faces in the font file.  Some font formats can have
    ///   multiple faces in a single font file.
    public var numFaces: FT_Long {
        return self.num_faces
    }
        
    /// face_index ::
    ///   This field holds two different values.  Bits 0-15 are the index of
    ///   the face in the font file (starting with value~0).  They are set
    ///   to~0 if there is only one face in the font file.
    ///
    /// [Since 2.6.1] Bits 16-30 are relevant to GX and OpenType variation
    /// fonts only, holding the named instance index for the current face
    /// index (starting with value~1; value~0 indicates font access without
    /// a named instance).  For non-variation fonts, bits 16-30 are ignored.
    /// If we have the third named instance of face~4, say, `face_index` is
    /// set to 0x00030004.
    ///
    /// Bit 31 is always zero (this is, `face_index` is always a positive
    /// value).
    ///
    /// [Since 2.9] Changing the design coordinates with
    /// @FT_Set_Var_Design_Coordinates or @FT_Set_Var_Blend_Coordinates does
    /// not influence the named instance index value (only
    /// @FT_Set_Named_Instance does that).
    public var faceIndex: FT_Long {
        return self.face_index
    }
    
//        *   face_flags ::
//        *     A set of bit flags that give important information about the face;
//        *     see @FT_FACE_FLAG_XXX for the details.
//    public var face_flags: FT_Long {
//
//    }
    
//    *   style_flags ::
//    *     The lower 16~bits contain a set of bit flags indicating the style of
//    *     the face; see @FT_STYLE_FLAG_XXX for the details.
//    *
//    *     [Since 2.6.1] Bits 16-30 hold the number of named instances
//    *     available for the current face if we have a GX or OpenType variation
//    *     (sub)font.  Bit 31 is always zero (this is, `style_flags` is always
//    *     a positive value).  Note that a variation font has always at least
//    *     one named instance, namely the default instance.
//    public var style_flags: FT_Long
    
    /// num_glyphs ::
    ///   The number of glyphs in the face.  If the face is scalable and has
    ///   sbits (see `num_fixed_sizes`), it is set to the number of outline
    ///   glyphs.
    ///
    ///   For CID-keyed fonts (not in an SFNT wrapper) this value gives the
    ///   highest CID used in the font.
    public var numGlyphs: FT_Long {
        return self.num_glyphs
    }

    /// family_name ::
    ///   The face's family name.  This is an ASCII string, usually in
    ///   English, that describes the typeface's family (like 'Times New
    ///   Roman', 'Bodoni', 'Garamond', etc).  This is a least common
    ///   denominator used to list fonts.  Some formats (TrueType & OpenType)
    ///   provide localized and Unicode versions of this string.  Applications
    ///   should use the format-specific interface to access them.  Can be
    ///   `NULL` (e.g., in fonts embedded in a PDF file).
    ///
    ///   In case the font doesn't provide a specific family name entry,
    ///   FreeType tries to synthesize one, deriving it from other name
    ///   entries.
    public var familyName: String? {
        guard let name = self.family_name else {return nil}
        return String(cString: name)
    }

    /// style_name ::
    ///   The face's style name.  This is an ASCII string, usually in English,
    ///   that describes the typeface's style (like 'Italic', 'Bold',
    ///   'Condensed', etc).  Not all font formats provide a style name, so
    ///   this field is optional, and can be set to `NULL`.  As for
    ///   `family_name`, some formats provide localized and Unicode versions
    ///   of this string.  Applications should use the format-specific
    ///   interface to access them.
    public var styleName: String? {
        guard let name = self.style_name else {return nil}
        return String(cString: name)
    }
        
    public var numFixedSizes: FT_Int {
        return self.num_fixed_sizes
    }
//    public var available_sizes: UnsafeMutablePointer<FT_Bitmap_Size>!
    public var numCharmaps: FT_Int {
        self.num_charmaps
    }
//    public var charmaps: UnsafeMutablePointer<FT_CharMap?>!
//    public var generic: FT_Generic

    
    /*# The following member variables (down to `underline_thickness`) */
    /*# are only relevant to scalable outlines; cf. @FT_Bitmap_Size    */
    /*# for bitmap fonts.                                              */
//    public var bbox: FT_BBox
    public var unitsPerEM: FT_UShort {
        self.units_per_EM
    }
    
    public var ascender: FT_Short {
        self.raw.pointee.ascender
    }
    
    public var descender: FT_Short {
        self.raw.pointee.descender
    }
    
    public var height: FT_Short {
        self.raw.pointee.height
    }
    
    public var maxAdvanceWidth: FT_Short {
        self.max_advance_width
    }
    
    public var maxAdvanceHeight: FT_Short {
        self.max_advance_height
    }
    
    public var underlinePosition: FT_Short {
        self.underline_position
    }
    
    public var underlineThickness: FT_Short {
        self.underline_thickness
    }
//    public var glyph: FT_GlyphSlot!
//    public var size: FT_Size!
//    public var charmap: FT_CharMap!
    /*@private begin */
//
//    public var driver: FT_Driver!
//    public var memory: FT_Memory!
//    public var stream: FT_Stream!
//    public var sizes_list: FT_ListRec
//    public var autohint: FT_Generic /* face-specific auto-hinter data */
//    public var extensions: UnsafeMutableRawPointer! /* unused                         */
//    public var `internal`: FT_Face_Internal!
}
