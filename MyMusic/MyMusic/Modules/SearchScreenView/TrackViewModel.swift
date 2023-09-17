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
    
    private let dataManager = AppAssembler.resolve(DataProtocol.self)

    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    private var savedTrackEntities: [TrackEntity] {
        return dataManager.fetchTracks()
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
        bindTrackInfo()
    }
    
    func saveTrack() {
        input.saveTrackSubject
            .sink { (trackTitle, trackArtists, trackImage, trackID) in
                self.output.isLiked = true
                if let currentImage = trackImage {
                    self.dataManager.addTrack(trackTitle: trackTitle,
                                         trackArtists: trackArtists,
                                         trackCover: currentImage,
                                         trackID: trackID)
                    //self.dataManagerModel.input.fetchDataSubject.send()
                }
            }
            .store(in: &cancellable)
    }
    
    func deleteTrack() {
        input.deleteTrackSubject
            .sink { trackID in
                self.dataManager.deleteTrack(trackID: trackID)
            }
            .store(in: &cancellable)
    }
    
    func checkFavoriteTrack() {
        input.checkFavoriteTrackSubject
            .sink { trackID in
                for track in self.savedTrackEntities {
                    if let currentUser = UserDefaults.standard.string(forKey: "email"),
                       track.userEmail == currentUser,
                       let id = track.trackID {
                        if id == trackID {
                            self.output.isLiked = true
                        }
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func bindTrackInfo() {
        input.sheetButtonSubject
            .sink { [weak self] in
                switch $0 {
                    case .trackInfo:
                        self?.output.sheet = .trackInfo
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
        let sheetButtonSubject = PassthroughSubject<Sheet, Never>()
    }
    
    struct Output {
        var isLiked: Bool = false
        var sheet: Sheet? = nil
    }
    
    enum Sheet: Identifiable {
        case trackInfo

        var id: Int {
            self.hashValue
        }
    }
}





