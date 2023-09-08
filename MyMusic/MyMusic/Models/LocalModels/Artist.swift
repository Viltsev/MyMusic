//
//  Artist.swift
//  MyMusic
//
//  Created by Данила on 04.09.2023.
//

import Foundation
import SwiftUI

struct ReceivedArtist: Identifiable {
    var id = UUID()
    let name: String
    let stats: Stats
    let visuals: Visuals
    var discography: Discography
}

struct Stats: Identifiable {
    var id = UUID()
    let followers: Int
    let worldRank: Int
}

struct Visuals: Identifiable {
    var id = UUID()
    let avatar: [Avatar]
}

struct Avatar: Identifiable {
    var id = UUID()
    let url: URL?
}

struct Discography: Identifiable {
    var id = UUID()
    var topTracks: [TopTracks]
}

struct TopTracks: Identifiable {
    var id = UUID()
    let trackID: String
    let name: String
    let durationMs: Int
    let playCount: Int
    let artists: [Artist]
    let album: ReceivedAlbum
}

struct ReceivedAlbum: Identifiable {
    var id = UUID()
    let cover: [Cover]
}
