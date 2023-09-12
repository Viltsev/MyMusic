//
//  ArtistModelMapper.swift
//  MyMusic
//
//  Created by Данила on 05.09.2023.
//

import Foundation

final class StatsModelMapper: BaseModelMapper<ServerStats, Stats> {
    
    override func toLocal(serverEntity: ServerStats) -> Stats {
        Stats(followers: serverEntity.followers ?? 0, worldRank: serverEntity.worldRank ?? 0)
    }
}

final class AvatarModelMapper: BaseModelMapper<ServerAvatar, Avatar> {
    
    override func toLocal(serverEntity: ServerAvatar) -> Avatar {
        Avatar(url: URL(string: serverEntity.url ?? "")) // change to string?
    }
}

final class VisualsModelMapper: BaseModelMapper<ServerVisuals, Visuals> {
    
    override func toLocal(serverEntity: ServerVisuals) -> Visuals {
        Visuals(avatar: AvatarModelMapper().toLocal(list: serverEntity.avatar))
    }
}

final class ReceivedAlbumModelMapper: BaseModelMapper<ServerReceivedAlbum, ReceivedAlbum> {
    
    override func toLocal(serverEntity: ServerReceivedAlbum) -> ReceivedAlbum {
        ReceivedAlbum(cover: CoverModelMapper().toLocal(list: serverEntity.cover))
    }
}

final class TopTracksModelMapper: BaseModelMapper<ServerTopTracks, TopTracks> {
    
    override func toLocal(serverEntity: ServerTopTracks) -> TopTracks {
        TopTracks(trackID: serverEntity.id ?? "",
                  name: serverEntity.name ?? "",
                  durationMs: serverEntity.durationMs ?? 0,
                  playCount: serverEntity.playCount ?? 0,
                  artists: ArtistModelMapper().toLocal(list: serverEntity.artists),
                  album: ReceivedAlbumModelMapper().toLocal(serverEntity: serverEntity.album ?? ServerReceivedAlbum(cover: [])))
    }
}

final class DiscographyModelMapper: BaseModelMapper<ServerDiscography, Discography> {
    
    override func toLocal(serverEntity: ServerDiscography) -> Discography {
        Discography(topTracks: TopTracksModelMapper().toLocal(list: serverEntity.topTracks))
    }
}

final class ReceivedArtistModelMapper: BaseModelMapper<ServerReceivedArtist, ReceivedArtist> {
    
    override func toLocal(serverEntity: ServerReceivedArtist) -> ReceivedArtist {
        ReceivedArtist(artistID: serverEntity.id ?? "", name: serverEntity.name ?? "",
                       stats: StatsModelMapper().toLocal(serverEntity: serverEntity.stats ?? ServerStats(followers: 0, worldRank: 0)),
                       visuals: VisualsModelMapper().toLocal(serverEntity: serverEntity.visuals ?? ServerVisuals(avatar: [])),
                       discography: DiscographyModelMapper().toLocal(serverEntity: serverEntity.discography ?? ServerDiscography(topTracks: [])))
    }
}

