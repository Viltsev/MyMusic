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
    
    var successNextTrackReceive: AnyPublisher<Bool, Never> {
        return input.successNextTrackReceiveSubject.eraseToAnyPublisher()
    }
    
    init() {
     bind()
    }
 }

 extension TrackInfoViewModel {
     func bind() {
         bindTrackLyrics()
         bindNextTrack()
         bindSheetAction()
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
                 self.input.sheetButtonSubject.send(.trackInfo)
                 self.output.lyrics = lyrics
             }
             .store(in: &cancellable)
     }
     
     func bindNextTrack() {
         input.nextTrackSubject
             .sink { nextTrack in
                 self.output.nextTracksArray.insert(nextTrack, at: 0)
                 self.input.successNextTrackReceiveSubject.send(true)
             }
             .store(in: &cancellable)
     }
     
     func bindSheetAction() {
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

 extension TrackInfoViewModel {
     struct Input {
         let lyricsTrackSubject = PassthroughSubject<String, Never>()
         let nextTrackSubject = PassthroughSubject<String, Never>()
         let successNextTrackReceiveSubject = PassthroughSubject<Bool, Never>()
         let sheetButtonSubject = PassthroughSubject<Sheet, Never>()
     }
     
     struct Output {
         var lyrics: TrackText?
         var nextTracksArray: [String] = []
         var sheet: Sheet? = nil
     }
     
     enum Sheet: Identifiable {
         case trackInfo

         var id: Int {
             self.hashValue
         }
     }
 }
