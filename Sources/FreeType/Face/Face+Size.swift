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
 *   FT_Set_Pixel_Sizes
 *
 * @description:
 *   Call @FT_Request_Size to request the nominal size (in pixels).
 *
 * @inout:
 *   face ::
 *     A handle to the target face object.
 *
 * @input:
 *   pixel_width ::
 *     The nominal width, in pixels.
 *
 *   pixel_height ::
 *     The nominal height, in pixels.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   You should not rely on the resulting glyphs matching or being
 *   constrained to this pixel size.  Refer to @FT_Request_Size to
 *   understand how requested sizes relate to actual sizes.
 *
 *   Don't use this function if you are using the FreeType cache API.
 */
//public func FT_Set_Pixel_Sizes(_ face: FT_Face!, _ pixel_width: FT_UInt, _ pixel_height: FT_UInt) -> FT_Error
    public func setPixelSizes(size: Size) throws {
        let error = FT_Set_Pixel_Sizes(raw, size.width, size.height)
        if error != 0 {
            throw FreeTypeError.error(code: error)
        }
    }
    
/**************************************************************************
 *
 * @function:
 *   FT_Select_Size
 *
 * @description:
 *   Select a bitmap strike.  To be more precise, this function sets the
 *   scaling factors of the active @FT_Size object in a face so that
 *   bitmaps from this particular strike are taken by @FT_Load_Glyph and
 *   friends.
 *
 * @inout:
 *   face ::
 *     A handle to a target face object.
 *
 * @input:
 *   strike_index ::
 *     The index of the bitmap strike in the `available_sizes` field of
 *     @FT_FaceRec structure.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   For bitmaps embedded in outline fonts it is common that only a subset
 *   of the available glyphs at a given ppem value is available.  FreeType
 *   silently uses outlines if there is no bitmap for a given glyph index.
 *
 *   For GX and OpenType variation fonts, a bitmap strike makes sense only
 *   if the default instance is active (this is, no glyph variation takes
 *   place); otherwise, FreeType simply ignores bitmap strikes.  The same
 *   is true for all named instances that are different from the default
 *   instance.
 *
 *   Don't use this function if you are using the FreeType cache API.
 */
//public func FT_Select_Size(_ face: FT_Face!, _ strike_index: FT_Int) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Request_Size
 *
 * @description:
 *   Resize the scale of the active @FT_Size object in a face.
 *
 * @inout:
 *   face ::
 *     A handle to a target face object.
 *
 * @input:
 *   req ::
 *     A pointer to a @FT_Size_RequestRec.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   Although drivers may select the bitmap strike matching the request,
 *   you should not rely on this if you intend to select a particular
 *   bitmap strike.  Use @FT_Select_Size instead in that case.
 *
 *   The relation between the requested size and the resulting glyph size
 *   is dependent entirely on how the size is defined in the source face.
 *   The font designer chooses the final size of each glyph relative to
 *   this size.  For more information refer to
 *   'https://www.freetype.org/freetype2/docs/glyphs/glyphs-2.html'.
 *
 *   Contrary to @FT_Set_Char_Size, this function doesn't have special code
 *   to normalize zero-valued widths, heights, or resolutions (which lead
 *   to errors in most cases).
 *
 *   Don't use this function if you are using the FreeType cache API.
 */
//public func FT_Request_Size(_ face: FT_Face!, _ req: FT_Size_Request!) -> FT_Error


/**************************************************************************
 *
 * @function:
 *   FT_Set_Char_Size
 *
 * @description:
 *   Call @FT_Request_Size to request the nominal size (in points).
 *
 * @inout:
 *   face ::
 *     A handle to a target face object.
 *
 * @input:
 *   char_width ::
 *     The nominal width, in 26.6 fractional points.
 *
 *   char_height ::
 *     The nominal height, in 26.6 fractional points.
 *
 *   horz_resolution ::
 *     The horizontal resolution in dpi.
 *
 *   vert_resolution ::
 *     The vertical resolution in dpi.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   While this function allows fractional points as input values, the
 *   resulting ppem value for the given resolution is always rounded to the
 *   nearest integer.
 *
 *   If either the character width or height is zero, it is set equal to
 *   the other value.
 *
 *   If either the horizontal or vertical resolution is zero, it is set
 *   equal to the other value.
 *
 *   A character width or height smaller than 1pt is set to 1pt; if both
 *   resolution values are zero, they are set to 72dpi.
 *
 *   Don't use this function if you are using the FreeType cache API.
 */
//public func FT_Set_Char_Size(_ face: FT_Face!, _ char_width: FT_F26Dot6, _ char_height: FT_F26Dot6, _ horz_resolution: FT_UInt, _ vert_resolution: FT_UInt) -> FT_Error
}

