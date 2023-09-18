//
//  TrackInfoViewModel.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation
import Combine
import CombineExt

final class TrackInfoViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    let apiService = GenaralApi()
    
    var successLyricsReceive: AnyPublisher<Bool, Never> {
        return input.successLyricsReceiveSubject.eraseToAnyPublisher()
    }
    
    init() {
     bind()
    }
 }

 extension TrackInfoViewModel {
     func bind() {
         bindTrackLyrics()
     }
     
     func bindTrackLyrics() {
         let request = input.lyricsTrackSubject
             .map { [unowned self] trackID in
                 self.apiService.receiveLyrics(byID: trackID)
                     .materialize()
             }
             .switchToLatest()
             .share()
         
         request
             .failures()
             .sink { error in
                 print(error)
             }
             .store(in: &cancellable)
         
         request
             .values()
             .sink { [weak self] lyrics in
                 guard let self else { return }
                 self.input.successLyricsReceiveSubject.send(true)
                 self.output.lyrics = lyrics
             }
             .store(in: &cancellable)
     }
 }

 extension TrackInfoViewModel {
     struct Input {
         let lyricsTrackSubject = PassthroughSubject<String, Never>()
         let successLyricsReceiveSubject = PassthroughSubject<Bool, Never>()
     }
     
     struct Output {
         var lyrics: TrackText?
     }
 }



    
    
