//
//  LowerCaseStringFormatter.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import Foundation

class LowerCaseStringFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let str = obj as? NSString else { return nil }
        return str.lowercased as String
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string.lowercased() as NSString
        return true
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        return true
    }
}
