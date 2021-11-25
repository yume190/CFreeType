//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

public struct LoadFlag: OptionSet {
    public let rawValue: Int32
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    init(_ raw: Int32) {
        self.rawValue = raw
    }
    
    init(_ raw: Int) {
        self.rawValue = Int32(raw)
    }
    
    public static let DEFAULT: LoadFlag = .init(FT_LOAD_DEFAULT)
    public static let NO_SCALE: LoadFlag = .init(FT_LOAD_NO_SCALE)
    public static let NO_HINTING: LoadFlag = .init(FT_LOAD_NO_HINTING)
    public static let RENDER: LoadFlag = .init(FT_LOAD_RENDER)
    public static let NO_BITMAP: LoadFlag = .init(FT_LOAD_NO_BITMAP)
    public static let VERTICAL_LAYOUT: LoadFlag = .init(FT_LOAD_VERTICAL_LAYOUT)
    public static let FORCE_AUTOHINT: LoadFlag = .init(FT_LOAD_FORCE_AUTOHINT)
    public static let CROP_BITMAP: LoadFlag = .init(FT_LOAD_CROP_BITMAP)
    public static let PEDANTIC: LoadFlag = .init(FT_LOAD_PEDANTIC)
    public static let IGNORE_GLOBAL_ADVANCE_WIDTH: LoadFlag = .init(FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH)
    public static let NO_RECURSE: LoadFlag = .init(FT_LOAD_NO_RECURSE)
    public static let IGNORE_TRANSFORM: LoadFlag = .init(FT_LOAD_IGNORE_TRANSFORM)
    public static let MONOCHROME: LoadFlag = .init(FT_LOAD_MONOCHROME)
    public static let LINEAR_DESIGN: LoadFlag = .init(FT_LOAD_LINEAR_DESIGN)
    public static let NO_AUTOHINT: LoadFlag = .init(FT_LOAD_NO_AUTOHINT)
    
    /* Bits 16-19 are used by `FT_LOAD_TARGET_` */
    public static let COLOR: LoadFlag = .init(FT_LOAD_COLOR)
    public static let COMPUTE_METRICS: LoadFlag = .init(FT_LOAD_COMPUTE_METRICS)
    public static let BITMAP_METRICS_ONLY: LoadFlag = .init(FT_LOAD_BITMAP_METRICS_ONLY)
    
    /* used internally only by certain font drivers */
    public static let ADVANCE_ONLY: LoadFlag = .init(FT_LOAD_ADVANCE_ONLY)
    public static let SBITS_ONLY: LoadFlag = .init(FT_LOAD_SBITS_ONLY)
    
    /// #define FT_LOAD_TARGET_NORMAL  FT_LOAD_TARGET_( FT_RENDER_MODE_NORMAL )
    public static let TARGET_NORMAL: LoadFlag = .loadTarget(FT_RENDER_MODE_NORMAL)
    /// #define FT_LOAD_TARGET_LIGHT   FT_LOAD_TARGET_( FT_RENDER_MODE_LIGHT  )
    public static let TARGET_LIGHT: LoadFlag = .loadTarget(FT_RENDER_MODE_LIGHT)
    /// #define FT_LOAD_TARGET_MONO    FT_LOAD_TARGET_( FT_RENDER_MODE_MONO   )
    public static let TARGET_MONO: LoadFlag = .loadTarget(FT_RENDER_MODE_MONO)
    /// #define FT_LOAD_TARGET_LCD     FT_LOAD_TARGET_( FT_RENDER_MODE_LCD    )
    public static let TARGET_LCD: LoadFlag = .loadTarget(FT_RENDER_MODE_LCD)
    /// #define FT_LOAD_TARGET_LCD_V   FT_LOAD_TARGET_( FT_RENDER_MODE_LCD_V  )
    public static let TARGET_LCD_V: LoadFlag = .loadTarget(FT_RENDER_MODE_LCD_V)
    
    /// #define FT_LOAD_TARGET_( x )   ( (FT_Int32)( (x) & 15 ) << 16 )
    private static func loadTarget(_ mode: FT_Render_Mode_) -> LoadFlag {
        return .init(Int32(mode.rawValue & 15) << 16)
    }
}
