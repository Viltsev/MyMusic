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
    let artistID: String
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
    var albums: AlbumArtist
}

struct AlbumArtist: Identifiable {
    var id = UUID()
    let items: [AlbumItem]
}

struct AlbumItem: Identifiable {
    var id = UUID()
    let albumID: String
    let name: String
    let cover: [Cover]
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
