//
//  Text+Extension.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import SwiftUI

extension Text {
    init(_ text: Strings, locale: Language = .english_us) {
        self.init(text.rawValue.localized(locale))
    }
}

