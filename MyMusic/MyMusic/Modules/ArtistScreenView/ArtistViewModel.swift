//
//  ArtistViewModel.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation
import Combine
import CombineExt

final class ArtistViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    let apiService = GenaralApi()
    
    var successAlbumReceive: AnyPublisher<Bool, Never> {
        return input.successAlbumReceiveSubject.eraseToAnyPublisher()
    }
    
    init() {
     bind()
    }
 }

extension ArtistViewModel {
    func bind() {
        bindAlbumInfo()
    }
    
    func bindAlbumInfo() {
        let request = input.albumInfoSubject
            .map { [unowned self] albumID in
                self.apiService.receiveAlbum(byID: albumID)
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
            .sink { [weak self] album in
                guard let self else { return }
                self.input.successAlbumReceiveSubject.send(true)
                self.output.selectedAlbum = album
            }
            .store(in: &cancellable)
        
        input.albumTitleAndCoverSubject
            .sink { title, cover in
                self.output.albumTitle = title
                if let albumCover = cover {
                    self.output.albumCover = albumCover
                }
            }
            .store(in: &cancellable)
    }
 }

extension ArtistViewModel {
    
    struct Input {
        let albumInfoSubject = PassthroughSubject<String, Never>()
        let successAlbumReceiveSubject = PassthroughSubject<Bool, Never>()
        let albumTitleAndCoverSubject = PassthroughSubject<(String, URL?), Never>()
    }

    struct Output {
        var selectedAlbum: ReceivedArtistAlbums?
        var albumCover: URL?
        var albumTitle: String?
    }
    
}




    
    
