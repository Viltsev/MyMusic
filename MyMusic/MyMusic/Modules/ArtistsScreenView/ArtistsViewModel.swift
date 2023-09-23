//
//  ArtistsViewModel.swift
//  MyMusic
//
//  Created by Данила on 04.09.2023.
//

import Foundation
import Combine
import CombineExt

final class ArtistsViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension ArtistsViewModel {
    
    func bind() {
        bindSelectArtist()
        bindSelectTopTrack()
    }
    
    func bindSelectArtist() {
        input.selectArtistSubject
            .sink { artist in
                self.output.selectedArtist = artist
            }
            .store(in: &cancellable)
    }
    
    func bindSelectTopTrack() {
        input.selectTopTrackSubject
            .sink { trackTitle in
                self.output.selectedTopTrack = trackTitle
                self.output.isTopTrackLoad = true
            }
            .store(in: &cancellable)
    }
    
}

extension ArtistsViewModel {
    struct Input {
        let selectArtistSubject = PassthroughSubject<ReceivedArtist, Never>()
        let selectTopTrackSubject = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var selectedArtist: ReceivedArtist?
        var selectedTopTrack: String?
        var isTopTrackLoad: Bool?
    }
}