//
//  ServerArtist.swift
//  MyMusic
//
//  Created by Данила on 05.09.2023.
//

import Foundation
import SwiftUI

struct ServerReceivedArtist: Codable {
    let name: String?
    let stats: ServerStats?
    let visuals: ServerVisuals?
    let discography: ServerDiscography?
}

struct ServerStats: Codable {
    let followers: Int?
    let worldRank: Int?
}

struct ServerVisuals: Codable {
    let avatar: [ServerAvatar]?
}

struct ServerAvatar: Codable {
    let url: String?
}

struct ServerDiscography: Codable {
    var topTracks: [ServerTopTracks]?
}

struct ServerTopTracks: Codable {
    let id: String?
    let name: String?
    let durationMs: Int?
    let playCount: Int?
    let artists: [ServerArtist]?
    let album: ServerReceivedAlbum?
}

struct ServerReceivedAlbum: Codable {
    let cover: [ServerCover]?
}
