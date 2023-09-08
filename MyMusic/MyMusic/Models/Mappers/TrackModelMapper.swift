//
//  TrackModelMapper.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import Foundation

final class AudioModelMapper: BaseModelMapper<ServerAudio, Audio> {
    
    override func toLocal(serverEntity: ServerAudio) -> Audio {
        Audio(url: URL(string: serverEntity.url ?? ""))
    }
}

final class YoutubeVideoModelMapper: BaseModelMapper<ServerYoutubeVideo, YoutubeVideo> {
    
    override func toLocal(serverEntity: ServerYoutubeVideo) -> YoutubeVideo {
        YoutubeVideo(id: serverEntity.id ?? UUID().uuidString,
                     audio: AudioModelMapper().toLocal(list: serverEntity.audio))
    }
}

final class ArtistModelMapper: BaseModelMapper<ServerArtist, Artist> {
    override func toLocal(serverEntity: ServerArtist) -> Artist {
        Artist(idArtist: serverEntity.id ?? "", name: serverEntity.name ?? "",
               shareUrl: URL(string: serverEntity.shareUrl ?? ""))
    }
}

final class CoverModelMapper: BaseModelMapper<ServerCover, Cover> {
    override func toLocal(serverEntity: ServerCover) -> Cover {
        Cover(url: URL(string: serverEntity.url ?? ""))
    }
}

final class AlbumModelMapper: BaseModelMapper<ServerAlbum, Album> {
    override func toLocal(serverEntity: ServerAlbum) -> Album {
        Album(name: serverEntity.name ?? "", shareUrl: URL(string: serverEntity.shareUrl ?? ""), cover: CoverModelMapper().toLocal(list: serverEntity.cover))
    }
}

final class SpotifyTrackModelMapper: BaseModelMapper<ServerSpotifyTrack, SpotifyTrack> {
    override func toLocal(serverEntity: ServerSpotifyTrack) -> SpotifyTrack {
        SpotifyTrack(name: serverEntity.name ?? "", artists: ArtistModelMapper().toLocal(list: serverEntity.artists), album: AlbumModelMapper().toLocal(serverEntity: serverEntity.album ?? ServerAlbum(name: "", shareUrl: "", cover: [])), durationMs: serverEntity.durationMs ?? 0)
    }
}

final class TrackModelMapper: BaseModelMapper<ServerTrack, Track> {
    override func toLocal(serverEntity: ServerTrack) -> Track {
        Track(youtubeVideo: YoutubeVideoModelMapper().toLocal(serverEntity: serverEntity.youtubeVideo ?? ServerYoutubeVideo(id: "", audio: [])), spotifyTrack: SpotifyTrackModelMapper().toLocal(serverEntity: serverEntity.spotifyTrack ?? ServerSpotifyTrack(name: "", artists: [], album: ServerAlbum(name: "", shareUrl: "", cover: []), durationMs: 0)))
    }
}

//final class TrackModelMapper: BaseModelMapper<ServerTrack, Track> {
//    override func toLocal(serverEntity: ServerTrack) -> Track {
//        Track(youtubeVideo: YoutubeVideoModelMapper().toLocal(serverEntity: serverEntity.youtubeVideo!), spotifyTrack: SpotifyTrackModelMapper().toLocal(serverEntity: serverEntity.spotifyTrack!))
//    }
//}
