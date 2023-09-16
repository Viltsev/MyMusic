//
//  ServerAlbum.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import Foundation
import SwiftUI

struct ServerReceivedArtistAlbums: Codable {
    let tracks: ServerAlbumTracks?
}

struct ServerAlbumTracks: Codable {
    let items: [ServerItemTracks]?
}

struct ServerItemTracks: Codable {
    let id: String?
    let name: String?
    let artists: [ServerArtist]?
}
