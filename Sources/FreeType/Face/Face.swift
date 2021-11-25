//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

@dynamicMemberLookup
public final class Face {
    let raw: FT_Face
    let data: Data?
    
    private init(_ face: FT_Face, _ data: Data? = nil) {
        self.raw = face
        self.data = data
    }
    
    public static func file(library: Library, path: String) throws -> Face {
        var _face: FT_Face? = nil

        let err = FT_New_Face(library.raw, path, 0, &_face)
        if err != 0 {
            throw FreeTypeError.error(code: err)
        }
        guard let face = _face else {
            throw FreeTypeError.initFail
        }
        return .init(face)
    }
    
    public static func memory(library: Library, path: String) throws -> Face {
        var _face: FT_Face? = nil
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let pointer = data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            return UnsafePointer<UInt8>(OpaquePointer(pointer.baseAddress))
        }
        
        let err = FT_New_Memory_Face(library.raw, pointer, data.count, 0, &_face)
        
        if err != 0 {
            throw FreeTypeError.error(code: err)
        }
        guard let face = _face else {
            throw FreeTypeError.initFail
        }
        return .init(face, data)
    }
    
    internal subscript<T>(dynamicMember keyPath: KeyPath<FT_FaceRec_, T>) -> T {
        return self.raw.pointee[keyPath: keyPath]
    }
    
    public var size: Int {
        return self.data?.count ?? 0
    }
    
    deinit {
        FT_Done_Face(raw)
    }
}

extension Face: CustomStringConvertible {
    public var description: String {
        return """
        postscript name: \(getPostscriptName() ?? "")
        number of faces: \(numFaces)
        face index: \(faceIndex)
        face flags:
            hasHorizontal: \(hasHorizontal)
            hasVertical: \(hasVertical)
            hasKerning: \(hasKerning)
            hasFixedSizes: \(hasFixedSizes)
            hasGlyphNames: \(hasGlyphNames)
            hasColor: \(hasColor)
            hasMultipleMasters: \(hasMultipleMasters)
            isSFNT: \(isSFNT)
            isScalable: \(isScalable)
            isFixedWidth: \(isFixedWidth)
            isCIDKeyed: \(isCIDKeyed)
            isTricky: \(isTricky)
            isVariation: \(isVariation)
        style_flags
        number of glyphs: \(numGlyphs)
        family name: \(familyName ?? "")
        style name: \(styleName ?? "")
        number of fixed sizes: \(numFixedSizes)
        available_sizes
        number of charmaps: \(numCharmaps)
        charmaps
        generic
        scalable outlines:
            bbox
            units per EM: \(unitsPerEM)
            ascender: \(ascender)
            descender: \(descender)
            height: \(height)
            max advance width: \(maxAdvanceWidth)
            max advance height: \(maxAdvanceHeight)
            underline position: \(underlinePosition)
            underline thickness: \(underlineThickness)
        """
    }
}

extension Face {
    /**************************************************************************
     *
     * @function:
     *   FT_Get_Char_Index
     *
     * @description:
     *   Return the glyph index of a given character code.  This function uses
     *   the currently selected charmap to do the mapping.
     *
     * @input:
     *   face ::
     *     A handle to the source face object.
     *
     *   charcode ::
     *     The character code.
     *
     * @return:
     *   The glyph index.  0~means 'undefined character code'.
     *
     * @note:
     *   If you use FreeType to manipulate the contents of font files directly,
     *   be aware that the glyph index returned by this function doesn't always
     *   correspond to the internal indices used within the file.  This is done
     *   to ensure that value~0 always corresponds to the 'missing glyph'.  If
     *   the first glyph is not named '.notdef', then for Type~1 and Type~42
     *   fonts, '.notdef' will be moved into the glyph ID~0 position, and
     *   whatever was there will be moved to the position '.notdef' had.  For
     *   Type~1 fonts, if there is no '.notdef' glyph at all, then one will be
     *   created at index~0 and whatever was there will be moved to the last
     *   index -- Type~42 fonts are considered invalid under this condition.
     */
    //public func FT_Get_Char_Index(_ face: FT_Face!, _ charcode: FT_ULong) -> FT_UInt
    public func getCharIndex(unicode: UnicodeScalar) -> FT_UInt {
        return getCharIndex(charCode: FT_ULong(unicode.value))
    }
    
    public func getCharIndex(charCode: FT_ULong) -> FT_UInt {
        return FT_Get_Char_Index(raw, charCode)
    }
    
    /**************************************************************************
     *
     * @function:
     *   FT_Get_Name_Index
     *
     * @description:
     *   Return the glyph index of a given glyph name.
     *
     * @input:
     *   face ::
     *     A handle to the source face object.
     *
     *   glyph_name ::
     *     The glyph name.
     *
     * @return:
     *   The glyph index.  0~means 'undefined character code'.
     */
    //public func FT_Get_Name_Index(_ face: FT_Face!, _ glyph_name: UnsafePointer<FT_String>!) -> FT_UInt
    public func getNameIndex(glyphName: String) -> FT_UInt {
        return FT_Get_Name_Index(raw, glyphName)
    }
    
    /**************************************************************************
     *
     * @function:
     *   FT_Get_Postscript_Name
     *
     * @description:
     *   Retrieve the ASCII PostScript name of a given face, if available.
     *   This only works with PostScript, TrueType, and OpenType fonts.
     *
     * @input:
     *   face ::
     *     A handle to the source face object.
     *
     * @return:
     *   A pointer to the face's PostScript name.  `NULL` if unavailable.
     *
     * @note:
     *   The returned pointer is owned by the face and is destroyed with it.
     *
     *   For variation fonts, this string changes if you select a different
     *   instance, and you have to call `FT_Get_PostScript_Name` again to
     *   retrieve it.  FreeType follows Adobe TechNote #5902, 'Generating
     *   PostScript Names for Fonts Using OpenType Font Variations'.
     *
     *     https://download.macromedia.com/pub/developer/opentype/tech-notes/5902.AdobePSNameGeneration.html
     *
     *   [Since 2.9] Special PostScript names for named instances are only
     *   returned if the named instance is set with @FT_Set_Named_Instance (and
     *   the font has corresponding entries in its 'fvar' table).  If
     *   @FT_IS_VARIATION returns true, the algorithmically derived PostScript
     *   name is provided, not looking up special entries for named instances.
     */
    //public func FT_Get_Postscript_Name(_ face: FT_Face!) -> UnsafePointer<CChar>!
    public func getPostscriptName() -> String? {
        guard let name = FT_Get_Postscript_Name(raw) else {return nil}
        return String(cString: name)
    }
    
    /**************************************************************************
     *
     * @function:
     *   FT_Get_First_Char
     *
     * @description:
     *   Return the first character code in the current charmap of a given
     *   face, together with its corresponding glyph index.
     *
     * @input:
     *   face ::
     *     A handle to the source face object.
     *
     * @output:
     *   agindex ::
     *     Glyph index of first character code.  0~if charmap is empty.
     *
     * @return:
     *   The charmap's first character code.
     *
     * @note:
     *   You should use this function together with @FT_Get_Next_Char to parse
     *   all character codes available in a given charmap.  The code should
     *   look like this:
     *
     *   ```
     *     FT_ULong  charcode;
     *     FT_UInt   gindex;
     *
     *
     *     charcode = FT_Get_First_Char( face, &gindex );
     *     while ( gindex != 0 )
     *     {
     *       ... do something with (charcode,gindex) pair ...
     *
     *       charcode = FT_Get_Next_Char( face, charcode, &gindex );
     *     }
     *   ```
     *
     *   Be aware that character codes can have values up to 0xFFFFFFFF; this
     *   might happen for non-Unicode or malformed cmaps.  However, even with
     *   regular Unicode encoding, so-called 'last resort fonts' (using SFNT
     *   cmap format 13, see function @FT_Get_CMap_Format) normally have
     *   entries for all Unicode characters up to 0x1FFFFF, which can cause *a
     *   lot* of iterations.
     *
     *   Note that `*agindex` is set to~0 if the charmap is empty.  The result
     *   itself can be~0 in two cases: if the charmap is empty or if the
     *   value~0 is the first valid character code.
     */
    //public func FT_Get_First_Char(_ face: FT_Face!, _ agindex: UnsafeMutablePointer<FT_UInt>!) -> FT_ULong
    public func getFirstChar() -> (index: FT_UInt, charCode: FT_ULong) {
        var index: FT_UInt = 0
        let charCode = FT_Get_First_Char(raw, &index)
        return (index, charCode)
    }

    /**************************************************************************
     *
     * @function:
     *   FT_Get_Next_Char
     *
     * @description:
     *   Return the next character code in the current charmap of a given face
     *   following the value `char_code`, as well as the corresponding glyph
     *   index.
     *
     * @input:
     *   face ::
     *     A handle to the source face object.
     *
     *   char_code ::
     *     The starting character code.
     *
     * @output:
     *   agindex ::
     *     Glyph index of next character code.  0~if charmap is empty.
     *
     * @return:
     *   The charmap's next character code.
     *
     * @note:
     *   You should use this function with @FT_Get_First_Char to walk over all
     *   character codes available in a given charmap.  See the note for that
     *   function for a simple code example.
     *
     *   Note that `*agindex` is set to~0 when there are no more codes in the
     *   charmap.
     */
    //public func FT_Get_Next_Char(_ face: FT_Face!, _ char_code: FT_ULong, _ agindex: UnsafeMutablePointer<FT_UInt>!) -> FT_ULong
    public func getNextChar(unicode: UnicodeScalar) -> (index: FT_UInt, charCode: FT_ULong) {
        return getNextChar(charCode: FT_ULong(unicode.value))
    }
    
    public func getNextChar(charCode: FT_ULong) -> (index: FT_UInt, charCode: FT_ULong) {
        var index: FT_UInt = 0
        let charCode = FT_Get_Next_Char(raw, charCode, &index)
        return (index, charCode)
    }
}






/**************************************************************************
 *
 * @function:
 *   FT_Open_Face
 *
 * @description:
 *   Create a face object from a given resource described by @FT_Open_Args.
 *
 * @inout:
 *   library ::
 *     A handle to the library resource.
 *
 * @input:
 *   args ::
 *     A pointer to an `FT_Open_Args` structure that must be filled by the
 *     caller.
 *
 *   face_index ::
 *     This field holds two different values.  Bits 0-15 are the index of
 *     the face in the font file (starting with value~0).  Set it to~0 if
 *     there is only one face in the font file.
 *
 *     [Since 2.6.1] Bits 16-30 are relevant to GX and OpenType variation
 *     fonts only, specifying the named instance index for the current face
 *     index (starting with value~1; value~0 makes FreeType ignore named
 *     instances).  For non-variation fonts, bits 16-30 are ignored.
 *     Assuming that you want to access the third named instance in face~4,
 *     `face_index` should be set to 0x00030004.  If you want to access
 *     face~4 without variation handling, simply set `face_index` to
 *     value~4.
 *
 *     `FT_Open_Face` and its siblings can be used to quickly check whether
 *     the font format of a given font resource is supported by FreeType.
 *     In general, if the `face_index` argument is negative, the function's
 *     return value is~0 if the font format is recognized, or non-zero
 *     otherwise.  The function allocates a more or less empty face handle
 *     in `*aface` (if `aface` isn't `NULL`); the only two useful fields in
 *     this special case are `face->num_faces` and `face->style_flags`.
 *     For any negative value of `face_index`, `face->num_faces` gives the
 *     number of faces within the font file.  For the negative value
 *     '-(N+1)' (with 'N' a non-negative 16-bit value), bits 16-30 in
 *     `face->style_flags` give the number of named instances in face 'N'
 *     if we have a variation font (or zero otherwise).  After examination,
 *     the returned @FT_Face structure should be deallocated with a call to
 *     @FT_Done_Face.
 *
 * @output:
 *   aface ::
 *     A handle to a new face object.  If `face_index` is greater than or
 *     equal to zero, it must be non-`NULL`.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   Unlike FreeType 1.x, this function automatically creates a glyph slot
 *   for the face object that can be accessed directly through
 *   `face->glyph`.
 *
 *   Each new face object created with this function also owns a default
 *   @FT_Size object, accessible as `face->size`.
 *
 *   One @FT_Library instance can have multiple face objects, this is,
 *   @FT_Open_Face and its siblings can be called multiple times using the
 *   same `library` argument.
 *
 *   See the discussion of reference counters in the description of
 *   @FT_Reference_Face.
 *
 * @example:
 *   To loop over all faces, use code similar to the following snippet
 *   (omitting the error handling).
 *
 *   ```
 *     ...
 *     FT_Face  face;
 *     FT_Long  i, num_faces;
 *
 *
 *     error = FT_Open_Face( library, args, -1, &face );
 *     if ( error ) { ... }
 *
 *     num_faces = face->num_faces;
 *     FT_Done_Face( face );
 *
 *     for ( i = 0; i < num_faces; i++ )
 *     {
 *       ...
 *       error = FT_Open_Face( library, args, i, &face );
 *       ...
 *       FT_Done_Face( face );
 *       ...
 *     }
 *   ```
 *
 *   To loop over all valid values for `face_index`, use something similar
 *   to the following snippet, again without error handling.  The code
 *   accesses all faces immediately (thus only a single call of
 *   `FT_Open_Face` within the do-loop), with and without named instances.
 *
 *   ```
 *     ...
 *     FT_Face  face;
 *
 *     FT_Long  num_faces     = 0;
 *     FT_Long  num_instances = 0;
 *
 *     FT_Long  face_idx     = 0;
 *     FT_Long  instance_idx = 0;
 *
 *
 *     do
 *     {
 *       FT_Long  id = ( instance_idx << 16 ) + face_idx;
 *
 *
 *       error = FT_Open_Face( library, args, id, &face );
 *       if ( error ) { ... }
 *
 *       num_faces     = face->num_faces;
 *       num_instances = face->style_flags >> 16;
 *
 *       ...
 *
 *       FT_Done_Face( face );
 *
 *       if ( instance_idx < num_instances )
 *         instance_idx++;
 *       else
 *       {
 *         face_idx++;
 *         instance_idx = 0;
 *       }
 *
 *     } while ( face_idx < num_faces )
 *   ```
 */
//FT_Open_Face


/**************************************************************************
 *
 * @function:
 *   FT_Attach_File
 *
 * @description:
 *   Call @FT_Attach_Stream to attach a file.
 *
 * @inout:
 *   face ::
 *     The target face object.
 *
 * @input:
 *   filepathname ::
 *     The pathname.
 *
 * @return:
 *   FreeType error code.  0~means success.
 */
//public func FT_Attach_File(_ face: FT_Face!, _ filepathname: UnsafePointer<CChar>!) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Attach_Stream
 *
 * @description:
 *   'Attach' data to a face object.  Normally, this is used to read
 *   additional information for the face object.  For example, you can
 *   attach an AFM file that comes with a Type~1 font to get the kerning
 *   values and other metrics.
 *
 * @inout:
 *   face ::
 *     The target face object.
 *
 * @input:
 *   parameters ::
 *     A pointer to @FT_Open_Args that must be filled by the caller.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   The meaning of the 'attach' (i.e., what really happens when the new
 *   file is read) is not fixed by FreeType itself.  It really depends on
 *   the font format (and thus the font driver).
 *
 *   Client applications are expected to know what they are doing when
 *   invoking this function.  Most drivers simply do not implement file or
 *   stream attachments.
 */
//public func FT_Attach_Stream(_ face: FT_Face!, _ parameters: UnsafeMutablePointer<FT_Open_Args>!) -> FT_Error



/**************************************************************************
 *
 * @function:
 *   FT_Reference_Face
 *
 * @description:
 *   A counter gets initialized to~1 at the time an @FT_Face structure is
 *   created.  This function increments the counter.  @FT_Done_Face then
 *   only destroys a face if the counter is~1, otherwise it simply
 *   decrements the counter.
 *
 *   This function helps in managing life-cycles of structures that
 *   reference @FT_Face objects.
 *
 * @input:
 *   face ::
 *     A handle to a target face object.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @since:
 *   2.4.2
 */
//public func FT_Reference_Face(_ face: FT_Face!) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Set_Transform
 *
 * @description:
 *   Set the transformation that is applied to glyph images when they are
 *   loaded into a glyph slot through @FT_Load_Glyph.
 *
 * @inout:
 *   face ::
 *     A handle to the source face object.
 *
 * @input:
 *   matrix ::
 *     A pointer to the transformation's 2x2 matrix.  Use `NULL` for the
 *     identity matrix.
 *   delta ::
 *     A pointer to the translation vector.  Use `NULL` for the null vector.
 *
 * @note:
 *   This function is provided as a convenience, but keep in mind that
 *   @FT_Matrix coefficients are only 16.16 fixed point values, which can
 *   limit the accuracy of the results.  Using floating-point computations
 *   to perform the transform directly in client code instead will always
 *   yield better numbers.
 *
 *   The transformation is only applied to scalable image formats after the
 *   glyph has been loaded.  It means that hinting is unaltered by the
 *   transformation and is performed on the character size given in the
 *   last call to @FT_Set_Char_Size or @FT_Set_Pixel_Sizes.
 *
 *   Note that this also transforms the `face.glyph.advance` field, but
 *   **not** the values in `face.glyph.metrics`.
 */
//public func FT_Set_Transform(_ face: FT_Face!, _ matrix: UnsafeMutablePointer<FT_Matrix>!, _ delta: UnsafeMutablePointer<FT_Vector>!)

/**************************************************************************
 *
 * @function:
 *   FT_Get_Kerning
 *
 * @description:
 *   Return the kerning vector between two glyphs of the same face.
 *
 * @input:
 *   face ::
 *     A handle to a source face object.
 *
 *   left_glyph ::
 *     The index of the left glyph in the kern pair.
 *
 *   right_glyph ::
 *     The index of the right glyph in the kern pair.
 *
 *   kern_mode ::
 *     See @FT_Kerning_Mode for more information.  Determines the scale and
 *     dimension of the returned kerning vector.
 *
 * @output:
 *   akerning ::
 *     The kerning vector.  This is either in font units, fractional pixels
 *     (26.6 format), or pixels for scalable formats, and in pixels for
 *     fixed-sizes formats.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   Only horizontal layouts (left-to-right & right-to-left) are supported
 *   by this method.  Other layouts, or more sophisticated kernings, are
 *   out of the scope of this API function -- they can be implemented
 *   through format-specific interfaces.
 *
 *   Kerning for OpenType fonts implemented in a 'GPOS' table is not
 *   supported; use @FT_HAS_KERNING to find out whether a font has data
 *   that can be extracted with `FT_Get_Kerning`.
 */
//public func FT_Get_Kerning(_ face: FT_Face!, _ left_glyph: FT_UInt, _ right_glyph: FT_UInt, _ kern_mode: FT_UInt, _ akerning: UnsafeMutablePointer<FT_Vector>!) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Get_Track_Kerning
 *
 * @description:
 *   Return the track kerning for a given face object at a given size.
 *
 * @input:
 *   face ::
 *     A handle to a source face object.
 *
 *   point_size ::
 *     The point size in 16.16 fractional points.
 *
 *   degree ::
 *     The degree of tightness.  Increasingly negative values represent
 *     tighter track kerning, while increasingly positive values represent
 *     looser track kerning.  Value zero means no track kerning.
 *
 * @output:
 *   akerning ::
 *     The kerning in 16.16 fractional points, to be uniformly applied
 *     between all glyphs.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   Currently, only the Type~1 font driver supports track kerning, using
 *   data from AFM files (if attached with @FT_Attach_File or
 *   @FT_Attach_Stream).
 *
 *   Only very few AFM files come with track kerning data; please refer to
 *   Adobe's AFM specification for more details.
 */
//public func FT_Get_Track_Kerning(_ face: FT_Face!, _ point_size: FT_Fixed, _ degree: FT_Int, _ akerning: UnsafeMutablePointer<FT_Fixed>!) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Get_Glyph_Name
 *
 * @description:
 *   Retrieve the ASCII name of a given glyph in a face.  This only works
 *   for those faces where @FT_HAS_GLYPH_NAMES(face) returns~1.
 *
 * @input:
 *   face ::
 *     A handle to a source face object.
 *
 *   glyph_index ::
 *     The glyph index.
 *
 *   buffer_max ::
 *     The maximum number of bytes available in the buffer.
 *
 * @output:
 *   buffer ::
 *     A pointer to a target buffer where the name is copied to.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   An error is returned if the face doesn't provide glyph names or if the
 *   glyph index is invalid.  In all cases of failure, the first byte of
 *   `buffer` is set to~0 to indicate an empty name.
 *
 *   The glyph name is truncated to fit within the buffer if it is too
 *   long.  The returned string is always zero-terminated.
 *
 *   Be aware that FreeType reorders glyph indices internally so that glyph
 *   index~0 always corresponds to the 'missing glyph' (called '.notdef').
 *
 *   This function always returns an error if the config macro
 *   `FT_CONFIG_OPTION_NO_GLYPH_NAMES` is not defined in `ftoption.h`.
 */
//public func FT_Get_Glyph_Name(_ face: FT_Face!, _ glyph_index: FT_UInt, _ buffer: FT_Pointer!, _ buffer_max: FT_UInt) -> FT_Error



/**************************************************************************
 *
 * @function:
 *   FT_Select_Charmap
 *
 * @description:
 *   Select a given charmap by its encoding tag (as listed in
 *   `freetype.h`).
 *
 * @inout:
 *   face ::
 *     A handle to the source face object.
 *
 * @input:
 *   encoding ::
 *     A handle to the selected encoding.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   This function returns an error if no charmap in the face corresponds
 *   to the encoding queried here.
 *
 *   Because many fonts contain more than a single cmap for Unicode
 *   encoding, this function has some special code to select the one that
 *   covers Unicode best ('best' in the sense that a UCS-4 cmap is
 *   preferred to a UCS-2 cmap).  It is thus preferable to @FT_Set_Charmap
 *   in this case.
 */
//public func FT_Select_Charmap(_ face: FT_Face!, _ encoding: FT_Encoding) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Set_Charmap
 *
 * @description:
 *   Select a given charmap for character code to glyph index mapping.
 *
 * @inout:
 *   face ::
 *     A handle to the source face object.
 *
 * @input:
 *   charmap ::
 *     A handle to the selected charmap.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   This function returns an error if the charmap is not part of the face
 *   (i.e., if it is not listed in the `face->charmaps` table).
 *
 *   It also fails if an OpenType type~14 charmap is selected (which
 *   doesn't map character codes to glyph indices at all).
 */
//public func FT_Set_Charmap(_ face: FT_Face!, _ charmap: FT_CharMap!) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Face_Properties
 *
 * @description:
 *   Set or override certain (library or module-wide) properties on a
 *   face-by-face basis.  Useful for finer-grained control and avoiding
 *   locks on shared structures (threads can modify their own faces as they
 *   see fit).
 *
 *   Contrary to @FT_Property_Set, this function uses @FT_Parameter so that
 *   you can pass multiple properties to the target face in one call.  Note
 *   that only a subset of the available properties can be controlled.
 *
 *   * @FT_PARAM_TAG_STEM_DARKENING (stem darkening, corresponding to the
 *     property `no-stem-darkening` provided by the 'autofit', 'cff',
 *     'type1', and 't1cid' modules; see @no-stem-darkening).
 *
 *   * @FT_PARAM_TAG_LCD_FILTER_WEIGHTS (LCD filter weights, corresponding
 *     to function @FT_Library_SetLcdFilterWeights).
 *
 *   * @FT_PARAM_TAG_RANDOM_SEED (seed value for the CFF, Type~1, and CID
 *     'random' operator, corresponding to the `random-seed` property
 *     provided by the 'cff', 'type1', and 't1cid' modules; see
 *     @random-seed).
 *
 *   Pass `NULL` as `data` in @FT_Parameter for a given tag to reset the
 *   option and use the library or module default again.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 *   num_properties ::
 *     The number of properties that follow.
 *
 *   properties ::
 *     A handle to an @FT_Parameter array with `num_properties` elements.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @example:
 *   Here is an example that sets three properties.  You must define
 *   `FT_CONFIG_OPTION_SUBPIXEL_RENDERING` to make the LCD filter examples
 *   work.
 *
 *   ```
 *     FT_Parameter         property1;
 *     FT_Bool              darken_stems = 1;
 *
 *     FT_Parameter         property2;
 *     FT_LcdFiveTapFilter  custom_weight =
 *                            { 0x11, 0x44, 0x56, 0x44, 0x11 };
 *
 *     FT_Parameter         property3;
 *     FT_Int32             random_seed = 314159265;
 *
 *     FT_Parameter         properties[3] = { property1,
 *                                            property2,
 *                                            property3 };
 *
 *
 *     property1.tag  = FT_PARAM_TAG_STEM_DARKENING;
 *     property1.data = &darken_stems;
 *
 *     property2.tag  = FT_PARAM_TAG_LCD_FILTER_WEIGHTS;
 *     property2.data = custom_weight;
 *
 *     property3.tag  = FT_PARAM_TAG_RANDOM_SEED;
 *     property3.data = &random_seed;
 *
 *     FT_Face_Properties( face, 3, properties );
 *   ```
 *
 *   The next example resets a single property to its default value.
 *
 *   ```
 *     FT_Parameter  property;
 *
 *
 *     property.tag  = FT_PARAM_TAG_LCD_FILTER_WEIGHTS;
 *     property.data = NULL;
 *
 *     FT_Face_Properties( face, 1, &property );
 *   ```
 *
 * @since:
 *   2.8
 *
 */
//public func FT_Face_Properties(_ face: FT_Face!, _ num_properties: FT_UInt, _ properties: UnsafeMutablePointer<FT_Parameter>!) -> FT_Error



/**************************************************************************
 *
 * @function:
 *   FT_Get_Color_Glyph_Layer
 *
 * @description:
 *   This is an interface to the 'COLR' table in OpenType fonts to
 *   iteratively retrieve the colored glyph layers associated with the
 *   current glyph slot.
 *
 *     https://docs.microsoft.com/en-us/typography/opentype/spec/colr
 *
 *   The glyph layer data for a given glyph index, if present, provides an
 *   alternative, multi-color glyph representation: Instead of rendering
 *   the outline or bitmap with the given glyph index, glyphs with the
 *   indices and colors returned by this function are rendered layer by
 *   layer.
 *
 *   The returned elements are ordered in the z~direction from bottom to
 *   top; the 'n'th element should be rendered with the associated palette
 *   color and blended on top of the already rendered layers (elements 0,
 *   1, ..., n-1).
 *
 * @input:
 *   face ::
 *     A handle to the parent face object.
 *
 *   base_glyph ::
 *     The glyph index the colored glyph layers are associated with.
 *
 * @inout:
 *   iterator ::
 *     An @FT_LayerIterator object.  For the first call you should set
 *     `iterator->p` to `NULL`.  For all following calls, simply use the
 *     same object again.
 *
 * @output:
 *   aglyph_index ::
 *     The glyph index of the current layer.
 *
 *   acolor_index ::
 *     The color index into the font face's color palette of the current
 *     layer.  The value 0xFFFF is special; it doesn't reference a palette
 *     entry but indicates that the text foreground color should be used
 *     instead (to be set up by the application outside of FreeType).
 *
 *     The color palette can be retrieved with @FT_Palette_Select.
 *
 * @return:
 *   Value~1 if everything is OK.  If there are no more layers (or if there
 *   are no layers at all), value~0 gets returned.  In case of an error,
 *   value~0 is returned also.
 *
 * @note:
 *   This function is necessary if you want to handle glyph layers by
 *   yourself.  In particular, functions that operate with @FT_GlyphRec
 *   objects (like @FT_Get_Glyph or @FT_Glyph_To_Bitmap) don't have access
 *   to this information.
 *
 *   Note that @FT_Render_Glyph is able to handle colored glyph layers
 *   automatically if the @FT_LOAD_COLOR flag is passed to a previous call
 *   to @FT_Load_Glyph.  [This is an experimental feature.]
 *
 * @example:
 *   ```
 *     FT_Color*         palette;
 *     FT_LayerIterator  iterator;
 *
 *     FT_Bool  have_layers;
 *     FT_UInt  layer_glyph_index;
 *     FT_UInt  layer_color_index;
 *
 *
 *     error = FT_Palette_Select( face, palette_index, &palette );
 *     if ( error )
 *       palette = NULL;
 *
 *     iterator.p  = NULL;
 *     have_layers = FT_Get_Color_Glyph_Layer( face,
 *                                             glyph_index,
 *                                             &layer_glyph_index,
 *                                             &layer_color_index,
 *                                             &iterator );
 *
 *     if ( palette && have_layers )
 *     {
 *       do
 *       {
 *         FT_Color  layer_color;
 *
 *
 *         if ( layer_color_index == 0xFFFF )
 *           layer_color = text_foreground_color;
 *         else
 *           layer_color = palette[layer_color_index];
 *
 *         // Load and render glyph `layer_glyph_index', then
 *         // blend resulting pixmap (using color `layer_color')
 *         // with previously created pixmaps.
 *
 *       } while ( FT_Get_Color_Glyph_Layer( face,
 *                                           glyph_index,
 *                                           &layer_glyph_index,
 *                                           &layer_color_index,
 *                                           &iterator ) );
 *     }
 *   ```
 */
//public func FT_Get_Color_Glyph_Layer(_ face: FT_Face!, _ base_glyph: FT_UInt, _ aglyph_index: UnsafeMutablePointer<FT_UInt>!, _ acolor_index: UnsafeMutablePointer<FT_UInt>!, _ iterator: UnsafeMutablePointer<FT_LayerIterator>!) -> FT_Bool

/**************************************************************************
 *
 * @function:
 *   FT_Get_FSType_Flags
 *
 * @description:
 *   Return the `fsType` flags for a font.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 * @return:
 *   The `fsType` flags, see @FT_FSTYPE_XXX.
 *
 * @note:
 *   Use this function rather than directly reading the `fs_type` field in
 *   the @PS_FontInfoRec structure, which is only guaranteed to return the
 *   correct results for Type~1 fonts.
 *
 * @since:
 *   2.3.8
 */
//public func FT_Get_FSType_Flags(_ face: FT_Face!) -> FT_UShort

/**************************************************************************
 *
 * @function:
 *   FT_Face_GetCharVariantIndex
 *
 * @description:
 *   Return the glyph index of a given character code as modified by the
 *   variation selector.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 *   charcode ::
 *     The character code point in Unicode.
 *
 *   variantSelector ::
 *     The Unicode code point of the variation selector.
 *
 * @return:
 *   The glyph index.  0~means either 'undefined character code', or
 *   'undefined selector code', or 'no variation selector cmap subtable',
 *   or 'current CharMap is not Unicode'.
 *
 * @note:
 *   If you use FreeType to manipulate the contents of font files directly,
 *   be aware that the glyph index returned by this function doesn't always
 *   correspond to the internal indices used within the file.  This is done
 *   to ensure that value~0 always corresponds to the 'missing glyph'.
 *
 *   This function is only meaningful if
 *     a) the font has a variation selector cmap sub table, and
 *     b) the current charmap has a Unicode encoding.
 *
 * @since:
 *   2.3.6
 */
//public func FT_Face_GetCharVariantIndex(_ face: FT_Face!, _ charcode: FT_ULong, _ variantSelector: FT_ULong) -> FT_UInt


/**************************************************************************
 *
 * @function:
 *   FT_Face_GetCharVariantIsDefault
 *
 * @description:
 *   Check whether this variation of this Unicode character is the one to
 *   be found in the charmap.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 *   charcode ::
 *     The character codepoint in Unicode.
 *
 *   variantSelector ::
 *     The Unicode codepoint of the variation selector.
 *
 * @return:
 *   1~if found in the standard (Unicode) cmap, 0~if found in the variation
 *   selector cmap, or -1 if it is not a variation.
 *
 * @note:
 *   This function is only meaningful if the font has a variation selector
 *   cmap subtable.
 *
 * @since:
 *   2.3.6
 */
//public func FT_Face_GetCharVariantIsDefault(_ face: FT_Face!, _ charcode: FT_ULong, _ variantSelector: FT_ULong) -> FT_Int

/**************************************************************************
 *
 * @function:
 *   FT_Face_GetVariantSelectors
 *
 * @description:
 *   Return a zero-terminated list of Unicode variation selectors found in
 *   the font.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 * @return:
 *   A pointer to an array of selector code points, or `NULL` if there is
 *   no valid variation selector cmap subtable.
 *
 * @note:
 *   The last item in the array is~0; the array is owned by the @FT_Face
 *   object but can be overwritten or released on the next call to a
 *   FreeType function.
 *
 * @since:
 *   2.3.6
 */
//public func FT_Face_GetVariantSelectors(_ face: FT_Face!) -> UnsafeMutablePointer<FT_UInt32>!

/**************************************************************************
 *
 * @function:
 *   FT_Face_GetVariantsOfChar
 *
 * @description:
 *   Return a zero-terminated list of Unicode variation selectors found for
 *   the specified character code.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 *   charcode ::
 *     The character codepoint in Unicode.
 *
 * @return:
 *   A pointer to an array of variation selector code points that are
 *   active for the given character, or `NULL` if the corresponding list is
 *   empty.
 *
 * @note:
 *   The last item in the array is~0; the array is owned by the @FT_Face
 *   object but can be overwritten or released on the next call to a
 *   FreeType function.
 *
 * @since:
 *   2.3.6
 */
//public func FT_Face_GetVariantsOfChar(_ face: FT_Face!, _ charcode: FT_ULong) -> UnsafeMutablePointer<FT_UInt32>!

/**************************************************************************
 *
 * @function:
 *   FT_Face_GetCharsOfVariant
 *
 * @description:
 *   Return a zero-terminated list of Unicode character codes found for the
 *   specified variation selector.
 *
 * @input:
 *   face ::
 *     A handle to the source face object.
 *
 *   variantSelector ::
 *     The variation selector code point in Unicode.
 *
 * @return:
 *   A list of all the code points that are specified by this selector
 *   (both default and non-default codes are returned) or `NULL` if there
 *   is no valid cmap or the variation selector is invalid.
 *
 * @note:
 *   The last item in the array is~0; the array is owned by the @FT_Face
 *   object but can be overwritten or released on the next call to a
 *   FreeType function.
 *
 * @since:
 *   2.3.6
 */
//public func FT_Face_GetCharsOfVariant(_ face: FT_Face!, _ variantSelector: FT_ULong) -> UnsafeMutablePointer<FT_UInt32>!

/**************************************************************************
 *
 * @function:
 *   FT_Get_Sfnt_Table
 *
 * @description:
 *   Return a pointer to a given SFNT table stored within a face.
 *
 * @input:
 *   face ::
 *     A handle to the source.
 *
 *   tag ::
 *     The index of the SFNT table.
 *
 * @return:
 *   A type-less pointer to the table.  This will be `NULL` in case of
 *   error, or if the corresponding table was not found **OR** loaded from
 *   the file.
 *
 *   Use a typecast according to `tag` to access the structure elements.
 *
 * @note:
 *   The table is owned by the face object and disappears with it.
 *
 *   This function is only useful to access SFNT tables that are loaded by
 *   the sfnt, truetype, and opentype drivers.  See @FT_Sfnt_Tag for a
 *   list.
 *
 * @example:
 *   Here is an example demonstrating access to the 'vhea' table.
 *
 *   ```
 *     TT_VertHeader*  vert_header;
 *
 *
 *     vert_header =
 *       (TT_VertHeader*)FT_Get_Sfnt_Table( face, FT_SFNT_VHEA );
 *   ```
 */
//public func FT_Get_Sfnt_Table(_ face: FT_Face!, _ tag: FT_Sfnt_Tag) -> UnsafeMutableRawPointer!

/**************************************************************************
 *
 * @function:
 *   FT_Load_Sfnt_Table
 *
 * @description:
 *   Load any SFNT font table into client memory.
 *
 * @input:
 *   face ::
 *     A handle to the source face.
 *
 *   tag ::
 *     The four-byte tag of the table to load.  Use value~0 if you want to
 *     access the whole font file.  Otherwise, you can use one of the
 *     definitions found in the @FT_TRUETYPE_TAGS_H file, or forge a new
 *     one with @FT_MAKE_TAG.
 *
 *   offset ::
 *     The starting offset in the table (or file if tag~==~0).
 *
 * @output:
 *   buffer ::
 *     The target buffer address.  The client must ensure that the memory
 *     array is big enough to hold the data.
 *
 * @inout:
 *   length ::
 *     If the `length` parameter is `NULL`, try to load the whole table.
 *     Return an error code if it fails.
 *
 *     Else, if `*length` is~0, exit immediately while returning the
 *     table's (or file) full size in it.
 *
 *     Else the number of bytes to read from the table or file, from the
 *     starting offset.
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   If you need to determine the table's length you should first call this
 *   function with `*length` set to~0, as in the following example:
 *
 *   ```
 *     FT_ULong  length = 0;
 *
 *
 *     error = FT_Load_Sfnt_Table( face, tag, 0, NULL, &length );
 *     if ( error ) { ... table does not exist ... }
 *
 *     buffer = malloc( length );
 *     if ( buffer == NULL ) { ... not enough memory ... }
 *
 *     error = FT_Load_Sfnt_Table( face, tag, 0, buffer, &length );
 *     if ( error ) { ... could not load table ... }
 *   ```
 *
 *   Note that structures like @TT_Header or @TT_OS2 can't be used with
 *   this function; they are limited to @FT_Get_Sfnt_Table.  Reason is that
 *   those structures depend on the processor architecture, with varying
 *   size (e.g. 32bit vs. 64bit) or order (big endian vs. little endian).
 *
 */
//public func FT_Load_Sfnt_Table(_ face: FT_Face!, _ tag: FT_ULong, _ offset: FT_Long, _ buffer: UnsafeMutablePointer<FT_Byte>!, _ length: UnsafeMutablePointer<FT_ULong>!) -> FT_Error

/**************************************************************************
 *
 * @function:
 *   FT_Sfnt_Table_Info
 *
 * @description:
 *   Return information on an SFNT table.
 *
 * @input:
 *   face ::
 *     A handle to the source face.
 *
 *   table_index ::
 *     The index of an SFNT table.  The function returns
 *     FT_Err_Table_Missing for an invalid value.
 *
 * @inout:
 *   tag ::
 *     The name tag of the SFNT table.  If the value is `NULL`,
 *     `table_index` is ignored, and `length` returns the number of SFNT
 *     tables in the font.
 *
 * @output:
 *   length ::
 *     The length of the SFNT table (or the number of SFNT tables,
 *     depending on `tag`).
 *
 * @return:
 *   FreeType error code.  0~means success.
 *
 * @note:
 *   While parsing fonts, FreeType handles SFNT tables with length zero as
 *   missing.
 *
 */
//public func FT_Sfnt_Table_Info(_ face: FT_Face!, _ table_index: FT_UInt, _ tag: UnsafeMutablePointer<FT_ULong>!, _ length: UnsafeMutablePointer<FT_ULong>!) -> FT_Error
