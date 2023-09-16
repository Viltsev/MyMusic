//
//  AlbumModelMapper.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import Foundation

final class ItemTracksMapper: BaseModelMapper<ServerItemTracks, ItemTracks> {
    override func toLocal(serverEntity: ServerItemTracks) -> ItemTracks {
        ItemTracks(itemID: serverEntity.id ?? "",
                   name: serverEntity.name ?? "",
                   artists: ArtistModelMapper().toLocal(list: serverEntity.artists))
    }
}

final class AlbumTracksMapper: BaseModelMapper<ServerAlbumTracks, AlbumTracks> {
    override func toLocal(serverEntity: ServerAlbumTracks) -> AlbumTracks {
        AlbumTracks(items: ItemTracksMapper().toLocal(list: serverEntity.items))
    }
}
     
final class ReceivedArtistAlbumsMapper: BaseModelMapper<ServerReceivedArtistAlbums, ReceivedArtistAlbums> {
    override func toLocal(serverEntity: ServerReceivedArtistAlbums) -> ReceivedArtistAlbums {
        ReceivedArtistAlbums(tracks: AlbumTracksMapper().toLocal(serverEntity: serverEntity.tracks ?? ServerAlbumTracks(items: [])))
    }
}
                                    
                                    
                                    

