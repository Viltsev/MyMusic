//
//  LyricsModelMapper.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation

final class LinesMapper: BaseModelMapper<ServerLines, Lines> {
    override func toLocal(serverEntity: ServerLines) -> Lines {
        Lines(words: serverEntity.words ?? "")
    }
}

final class LyricsMapper: BaseModelMapper<ServerLyrics, Lyrics> {
    override func toLocal(serverEntity: ServerLyrics) -> Lyrics {
        Lyrics(lines: LinesMapper().toLocal(list: serverEntity.lines))
    }
}

final class TrackTextMapper: BaseModelMapper<ServerTrackText, TrackText> {
    override func toLocal(serverEntity: ServerTrackText) -> TrackText {
        TrackText(lyrics: LyricsMapper().toLocal(serverEntity: serverEntity.lyrics ?? ServerLyrics(lines: [])))
    }
}
