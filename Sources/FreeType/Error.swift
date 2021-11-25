//
//  File.swift
//  
//
//  Created by Yume on 2021/11/24.
//

import Foundation
import CFreeType

public enum FreeTypeError: Error {
    case error(code: FT_Error)
    case initFail
}
