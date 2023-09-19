//
//  FavoriteMusicViewModel.swift
//  MyMusic
//
//  Created by Данила on 17.09.2023.
//

import Foundation
import Combine
import CombineExt

final class FavoriteMusicViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension FavoriteMusicViewModel {
    func bind() {
        input.addTopTrack
            .sink { title, artists in
                self.output.topTracks.append("\(title) \(artists)")
            }
            .store(in: &cancellable)
    }
}

extension FavoriteMusicViewModel {
    struct Input {
        let isTopTrackLoadSubject = PassthroughSubject<Void, Never>()
        let addTopTrack = PassthroughSubject<(String, String), Never>()
    }
    
    struct Output {
        var isTopTrackLoad: Bool = false
        var topTracks: [String] = []
    }
}


/*
final class FavoriteMusicViewModel: ObservableObject {
     let input: Input = Input()
     @Published var output: Output = Output()
     var cancellable = Set<AnyCancellable>()
     
     init() {
         bind()
     }
 }

extension FavoriteMusicViewModel {
     func bind() {
         
     }
 }

extension FavoriteMusicViewModel {
     struct Input {
         
     }
     
     struct Output {
         
     }
 }
 */
