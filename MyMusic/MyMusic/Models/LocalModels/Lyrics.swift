//
//  Lyrics.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation

struct TrackText {
    let lyrics: Lyrics
}

struct Lyrics: Identifiable {
    var id = UUID()
    let lines: [Lines]
}

struct Lines: Identifiable {
    var id = UUID()
    let words: String
}
