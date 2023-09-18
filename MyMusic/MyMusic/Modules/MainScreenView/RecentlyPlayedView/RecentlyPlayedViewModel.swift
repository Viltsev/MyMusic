//
//  RecentlyPlayedViewModel.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation
import Combine
import CombineExt

final class RecentlyPlayedViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GenaralApi()
    
    var successArtistReceive: AnyPublisher<Bool, Never> {
        return input.successArtistReceiveSubject.eraseToAnyPublisher()
    }
    
    init() {
     bind()
    }
}

extension RecentlyPlayedViewModel {
    func bind() {
        getArtistInfo()
    }
    
    func getArtistInfo() {
        let request = input.artistInfoSubject
            .map { [unowned self] artistID in
                self.apiService.receiveArtist(byID: artistID)
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
            .sink { [weak self] artist in
                guard let self else { return }
                self.input.successArtistReceiveSubject.send(true)
                self.output.selectedArtist = artist
            }
            .store(in: &cancellable)
    }
}

extension RecentlyPlayedViewModel {
    struct Input {
        let artistInfoSubject = PassthroughSubject<String, Never>()
        let successArtistReceiveSubject = PassthroughSubject<Bool, Never>()
    }

    struct Output {
        var selectedArtist: ReceivedArtist?
    }
}



    
   
