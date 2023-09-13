//
//  OptionalString+Extension.swift
//  MyMusic
//
//  Created by Данила on 13.09.2023.
//

import Foundation

extension Optional where Wrapped == String {
    
    var orEmpty: String {
        self ?? ""
    }
}
