//
//  Font.swift
//  Test
//
//  Created by Yume on 2021/11/22.
//

import Foundation
import CFreeType

//  def __init__(self, filename, size):
//    self.face = freetype.Face(filename)
//    self.face.set_pixel_sizes(0, size)
//
//  def render_character(self, char):
//    glyph = self.glyph_for_character(char)
//    return glyph.bitmap
//
//def text_dimensions(self, text):
//    """
//    Return (width, height, baseline) of `text` rendered in the current font.
//    """
//    width = 0
//    max_ascent = 0
//    max_descent = 0
//    previous_char = None
//
//    # For each character in the text string we get the glyph
//    # and update the overall dimensions of the resulting bitmap.
//    for char in text:
//      glyph = self.glyph_for_character(char)
//      max_ascent = max(max_ascent, glyph.ascent)
//      max_descent = max(max_descent, glyph.descent)
//      width += glyph.advance_width
//      previous_char = char
//
//    height = max_ascent + max_descent
//    return (width, height, max_descent)
//
//def render_text(self, text, width=None, height=None, baseline=None):
//    """
//    Render the given `text` into a Bitmap and return it.
//
//    If `width`, `height`, and `baseline` are not specified they
//    are computed using the `text_dimensions' method.
//    """
//    if None in (width, height, baseline):
//        width, height, baseline = self.text_dimensions(text)
//
//    x = 0
//    previous_char = None
//    outbuffer = Bitmap(width, height)
//
//    for char in text:
//      glyph = self.glyph_for_character(char)
//      y = height - glyph.ascent - baseline
//      outbuffer.bitblt(glyph.bitmap, x, y)
//      x += glyph.advance_width
//      previous_char = char
//
//    return outbuffer
//

//

//
//def text_dimensions(self, text):
//    width = 0
//    max_ascent = 0
//    max_descent = 0
//    previous_char = None
//
//    for char in text:
//      glyph = self.glyph_for_character(char)
//      max_ascent = max(max_ascent, glyph.ascent)
//      max_descent = max(max_descent, glyph.descent)
//      kerning_x = self.kerning_offset(previous_char, char)
//
//      # With kerning, the advance width may be less than the width of the
//      # glyph's bitmap. Make sure we compute the total width so that
//      # all of the glyph's pixels fit into the returned dimensions.
//      width += max(glyph.advance_width + kerning_x, glyph.width + kerning_x)
//
//      previous_char = char
//
//    height = max_ascent + max_descent
//    return (width, height, max_descent)





public class Font {
//    let path: String
    var lib: FT_Library
    var face: FT_Face
    var e: FT_Error?
    public init?(path: String, size: Size) {
        var lib: FT_Library? = nil
        e = FT_Init_FreeType(&lib)
        if e != 0 {
            return nil
        }
        guard let _lib = lib else {return nil}
        self.lib = _lib

        var face: FT_Face?
        e = FT_New_Face(lib, path, 0, &face)
        if e != 0 {
            FT_Done_FreeType(lib)
            return nil
        }
        guard let _face = face else {return nil}
        self.face = _face

        e = FT_Set_Pixel_Sizes(face, size.width, size.height)
        if e != 0 {
            FT_Done_Face(face)
            FT_Done_FreeType(lib)
            return nil
        }
    }

    deinit {
        FT_Done_Face(face)
        FT_Done_FreeType(lib)
    }

//    #define FT_LOAD_TARGET_( x )   ( (FT_Int32)( (x) & 15 ) << 16 )
//
//    #define FT_LOAD_TARGET_NORMAL  FT_LOAD_TARGET_( FT_RENDER_MODE_NORMAL )
//    #define FT_LOAD_TARGET_LIGHT   FT_LOAD_TARGET_( FT_RENDER_MODE_LIGHT  )
//    #define FT_LOAD_TARGET_MONO    FT_LOAD_TARGET_( FT_RENDER_MODE_MONO   )
//    #define FT_LOAD_TARGET_LCD     FT_LOAD_TARGET_( FT_RENDER_MODE_LCD    )
//    #define FT_LOAD_TARGET_LCD_V   FT_LOAD_TARGET_( FT_RENDER_MODE_LCD_V  )


    /// Let FreeType load the glyph for the given character and
    /// tell it to render a monochromatic bitmap representation.
    public func glyph(_ char: UnicodeScalar) -> Glyph {
        /// targetMono 0x0000000000020000
        let targetMono = Int((FT_RENDER_MODE_MONO.rawValue & 15) << 16)
        /// FT_LOAD_RENDER 0x0000000000000004
        FT_Load_Char(face, FT_ULong(char.value), FT_Int32(FT_LOAD_RENDER | targetMono))
        return Glyph.from(slot: self.face.pointee.glyph)
    }

    /// Return the horizontal kerning offset in pixels when rendering `char`
    /// after `previous_char`.
    func kerning_offset(previous_char: UnicodeScalar, char: UnicodeScalar) {

//        FT_Get_Kerning(self.face, FT_UInt(previous_char.value), char, <#T##kern_mode: FT_UInt##FT_UInt#>, <#T##akerning: UnsafeMutablePointer<FT_Vector>!##UnsafeMutablePointer<FT_Vector>!#>)
//        let kerning = self.face.pointee.

    //    kerning = self.face.get_kerning(previous_char, char)
    //
    //    # The kerning offset is given in FreeType's 26.6 fixed point format,
    //    # which means that the pixel values are multiples of 64.
    //    return kerning.x / 64
    }

    //    def render_text2(self, text, width=None, height=None, baseline=None):
//    func render(text: String, size: Size) {
//        //        if None in (width, height, baseline):
//        //            width, height, baseline = self.text_dimensions(text)
//        var x = 0
////        previous_char = None
////        outbuffer = Bitmap(width, height)
//
////        for char in text:
//        for char in text.unicodeScalars {
//            let glyph = self.glyph(char)
//
//            // Take kerning information into account before we render the
//            // glyph to the output bitmap.
//            x += self.kerning_offset(previous_char, char)
//
//            // The vertical drawing position should place the glyph
//            // on the baseline as intended.
//            y = height - glyph.ascent - baseline
//
//            outbuffer.bitblt(glyph.bitmap, x, y)
//
//            x += glyph.advance_width
//            previous_char = char
//        }
//
//        return outbuffer
//    }





    public func rrrr(text: String) {
        FT_Select_Charmap(face, FT_ENCODING_UNICODE);

        for s in text.unicodeScalars {
            let index = FT_Get_Char_Index(face, FT_ULong(s.value))
            FT_Load_Glyph(face, index, FT_LOAD_DEFAULT)
            if face.pointee.glyph.pointee.format != FT_GLYPH_FORMAT_BITMAP {
                if FT_Render_Glyph(face.pointee.glyph, FT_RENDER_MODE_MONO) != 0 {
                    continue
                }
            }

//            FT_Bitmap fon
        }
    }


//        for(int i=0; i<wcslen(texts); i++) {
//            unsigned int ucode = texts[i];
//            FT_UInt glyph_index = FT_Get_Char_Index(face, ucode);
//            if(!glyph_index) {
//                continue;
//            }
//
//            if (FT_Load_Glyph(face, glyph_index, FT_LOAD_DEFAULT)) {
//                continue;
//            }
//            if (face->glyph->format != FT_GLYPH_FORMAT_BITMAP) {
//                if (FT_Render_Glyph(face->glyph, FT_RENDER_MODE_MONO)) {
//                    continue;
//                }
//            }
//
//            Bitmap font = {    face->glyph->bitmap_left,
//                            face->glyph->bitmap_top - face->glyph->bitmap.rows,
//                            face->glyph->bitmap.width,
//                            face->glyph->bitmap.rows,
//                            face->glyph->bitmap.pitch,
//                            face->glyph->bitmap.buffer
//                          };
//            combinetext(bitmap, &font);
//        }
//
//        FT_Done_Face(face);
//        FT_Done_FreeType(library);
//
//        return true;


//          self.face.load_char(char, freetype.FT_LOAD_RENDER |
//                                    freetype.FT_LOAD_TARGET_MONO)
//          return Glyph.from_glyphslot(self.face.glyph)
}
