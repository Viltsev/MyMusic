//
//  ServerTrack.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import Foundation

struct ServerTrack: Codable {
    let youtubeVideo: ServerYoutubeVideo?
    let spotifyTrack: ServerSpotifyTrack?
}

struct ServerYoutubeVideo: Codable {
    let id: String?
    let audio: [ServerAudio]?
}

struct ServerAudio: Codable {
    let url: String?
    //let durationText: String?
}

struct ServerSpotifyTrack: Codable {
    let id: String?
    let name: String?
    let artists: [ServerArtist]?
    let album: ServerAlbum?
    let durationMs: Int?
}

struct ServerArtist: Codable {
    let id: String?
    let name: String?
    let shareUrl: String?
}

struct ServerAlbum: Codable {
    let name: String?
    let shareUrl: String?
    let cover: [ServerCover]?
}

struct ServerCover: Codable {
    let url: String?
}
