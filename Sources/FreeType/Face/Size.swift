//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

public struct Size {
    public let width: UInt32
    public let height: UInt32

    public init(_ square: FT_UInt) {
        self.width = square
        self.height = square
    }
    
    public init(width: UInt32, height: UInt32) {
        self.width = width
        self.height = height
    }
    
    public init(bitmap: FT_Bitmap) {
        self.init(width: bitmap.width, height: bitmap.rows)
    }
}
