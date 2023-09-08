//
//  AppData.swift
//  MyMusic
//
//  Created by Данила on 06.09.2023.
//

import Foundation

final class AppData: ObservableObject {
    @Published var track: Track?
    @Published var artists: [ReceivedArtist]?
    @Published var disabled: Bool
    
    func selectTrack(_ track: Track) {
        self.track = track
    }
    
    func selectArtists(_ artists: [ReceivedArtist]) {
        self.artists = artists
    }
    
    func setDisabled(_ disabled: Bool) {
        self.disabled = disabled
    }
    
    init(disabled: Bool) {
        self.disabled = disabled
    }
}
