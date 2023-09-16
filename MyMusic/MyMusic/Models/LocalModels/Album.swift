//
//  Album.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import Foundation
import SwiftUI

struct ReceivedArtistAlbums: Identifiable {
    var id = UUID()
    var tracks: AlbumTracks
}

struct AlbumTracks: Identifiable {
    var id = UUID()
    var items: [ItemTracks]
}

struct ItemTracks: Identifiable {
    var id = UUID()
    let itemID: String
    let name: String
    let artists: [Artist]
}
