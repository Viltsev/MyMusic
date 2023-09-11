//
//  Track.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import Foundation

struct Track: Identifiable {
    var id = UUID()
    let youtubeVideo: YoutubeVideo
    let spotifyTrack: SpotifyTrack
}

struct YoutubeVideo: Identifiable {
    let id: String
    let audio: [Audio]
}

struct Audio: Identifiable {
    var id = UUID()
    let url: URL?
    //let durationText: String
}

struct SpotifyTrack: Identifiable {
    var id = UUID()
    let trackID: String
    let name: String
    let artists: [Artist]
    let album: Album
    let durationMs: Int
}

struct Artist: Identifiable {
    var id = UUID()
    let idArtist: String
    let name: String
    let shareUrl: URL?
}

struct Album: Identifiable {
    var id = UUID()
    let name: String
    let shareUrl: URL?
    let cover: [Cover]
}

struct Cover: Identifiable {
    var id = UUID()
    let url: URL?
}
