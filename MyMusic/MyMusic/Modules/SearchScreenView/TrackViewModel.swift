//
//  TrackViewModel.swift
//  MyMusic
//
//  Created by Данила on 10.09.2023.
//

import Foundation
import Combine
import CombineExt

final class TrackViewModel: ObservableObject {
    var dataManager: DataManager? = nil
    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    func setDataManager(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    init() {
        bind()
    }
}

extension TrackViewModel {
    func bind() {
        saveTrack()
        deleteTrack()
        checkFavoriteTrack()
    }
    
    func saveTrack() {
        input.saveTrackSubject
            .sink { (trackTitle, trackArtists, trackImage, trackID) in
                self.output.isLiked = true
                if let dataManager = self.dataManager, let currentImage = trackImage {
                    dataManager.addTrack(trackTitle: trackTitle,
                                         trackArtists: trackArtists,
                                         trackCover: currentImage,
                                         trackID: trackID)
                }
            }
            .store(in: &cancellable)
    }
    
    func deleteTrack() {
        input.deleteTrackSubject
            .sink { trackID in
                if let dataManager = self.dataManager {
                    dataManager.deleteTrack(trackID: trackID)
                }
            }
            .store(in: &cancellable)
    }
    
    func checkFavoriteTrack() {
        input.checkFavoriteTrackSubject
            .sink { trackID in
                if let dataManager = self.dataManager {
                    for track in dataManager.savedTrackEntities {
                        if let currentUser = UserDefaults.standard.string(forKey: "email"),
                           track.userEmail == currentUser,
                           let id = track.trackID {
                            if id == trackID {
                                self.output.isLiked = true
                            }
                        }
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    
}

extension TrackViewModel {
    struct Input {
        let saveTrackSubject = PassthroughSubject<(String, String, URL?, String), Never>()
        let deleteTrackSubject = PassthroughSubject<String, Never>()
        let checkFavoriteTrackSubject = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var isLiked: Bool = false
    }
}
