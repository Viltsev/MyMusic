//
//  ServerLyrics.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation

struct ServerTrackText: Codable {
    let lyrics: ServerLyrics?
}

struct ServerLyrics: Codable {
    let lines: [ServerLines]?
}

struct ServerLines: Codable {
    let words: String?
}
