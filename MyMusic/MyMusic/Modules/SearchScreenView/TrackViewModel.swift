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
        input.saveTrackSubject
            .sink { (trackTitle, trackArtists, trackImage) in
                self.output.isLiked = true
                if let dataManager = self.dataManager {
                    for user in dataManager.savedEntities {
                        if let email = UserDefaults.standard.string(forKey: "email"), let currentImage = trackImage, user.email == email {
                            dataManager.addTrack(user: user,
                                                 trackTitle: trackTitle,
                                                 trackArtists: trackArtists,
                                                 trackCover: currentImage
                            )
                        }
                    }
                }
            }
            .store(in: &cancellable)
    }
}

extension TrackViewModel {
    struct Input {
        let saveTrackSubject = PassthroughSubject<(String, String, URL?), Never>()
    }
    
    struct Output {
        var isLiked: Bool = false
    }
}
