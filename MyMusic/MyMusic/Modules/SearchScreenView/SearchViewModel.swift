//
//  SearchViewModel.swift
//  MyMusic
//
//  Created by Данила on 23.08.2023.
//

import Foundation
import UIKit
import Combine
import CombineExt
import AVFoundation

final class SearchViewModel: ObservableObject {
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    var audioPlayer: AudioPlayer? = nil
    var router: NavigationRouter? = nil
    
    let apiService = GenaralApi()
    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    func setRouter(_ router: NavigationRouter) {
        self.router = router
    }
    
    func setAudioPlayer(_ player: AudioPlayer) {
        self.audioPlayer = player
    }

    var successArtistReceive: AnyPublisher<Bool, Never> {
        return input.successArtistReceiveSubject.eraseToAnyPublisher()
    }
    
    var successAlbumReceive: AnyPublisher<Bool, Never> {
        return input.successAlbumReceiveSubject.eraseToAnyPublisher()
    }
    
    init() {
        bind()
    }
}

extension SearchViewModel {
    
    func bind() {
        bindSearchButton()
        backToMainScreen()
        loadTopTrack()
        loadCurrentTrack()
        checkTopTrackLoad()
        saveRecentlyPlayedArtist()
        getArtistInfo()
        bindNextTrack()
        bindAlbumInfo()
    }
    
    func bindSearchButton() {
        let request = input.searchButtonTapSubject
            .map { [unowned self] trackName in
                self.apiService.getTrack(byName: trackName)
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
            .sink { [weak self] tracks in
                guard let self else { return }
                self.output.tracks = tracks
                if let audioPlayer = self.audioPlayer {
                    input.loadTrackSubject.send((tracks.youtubeVideo.audio.first?.url, audioPlayer))
                }
                getArtistsInfo()
            }
            .store(in: &cancellable)
    }
    
    func loadTopTrack() {
        input.selectedTopTrackSubject
            .sink { topTrack in
                self.input.searchButtonTapSubject.send(topTrack.name)
            }
            .store(in: &cancellable)
    }
    
    func backToMainScreen() {
        input.backButtonSubject
            .sink { [weak self] in
                self?.router?.popToRoot()
            }
            .store(in: &cancellable)
    }
    
    func loadCurrentTrack() {
        input.loadTrackSubject
            .sink { trackItem in
                let queue = DispatchQueue(label: "", qos: .background)
                queue.sync {
                    if let unwrappedAudioURL = trackItem.0 {
                        self.output.playerItem = trackItem.1.getTrackURL(from: unwrappedAudioURL)
                        self.output.isTrackLoaded.toggle()
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func checkTopTrackLoad() {
        input.isTopTrackLoadSubject
            .sink {
                self.output.isTopTrackLoad.toggle()
            }
            .store(in: &cancellable)
    }
    
    func getArtistsInfo() {
        if !self.output.artists.isEmpty {
            self.output.artists.removeAll()
        }
        
        let publishers = self.output.tracks.spotifyTrack.artists.map { artist in
            return self.apiService.receiveArtist(byID: artist.idArtist)
                .mapError { error -> Error in
                    return error
                }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { artist in
                self.output.artists.append(artist)
                self.input.recentlyPlayedArtistSubject.send(self.output.artists)
            })
            .store(in: &cancellable)
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
                if !self.output.artists.isEmpty {
                    self.output.artists.removeAll()
                }
                self.input.successArtistReceiveSubject.send(true)
                self.output.selectedArtist = artist
                //self.output.artists.append(artist)
            }
            .store(in: &cancellable)
    }
    
    func saveRecentlyPlayedArtist() {
        input.recentlyPlayedArtistSubject
            .sink { artists in
                for artist in artists {
                    if let currentCover = artist.visuals.avatar.first?.url {
                        self.dataManager.addArtist(name: artist.name,
                                              cover: currentCover,
                                              artistID: artist.artistID)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func bindNextTrack() {
        input.nextTrackSubject
            .sink { nextTrack in
                self.output.nextTracksArray.insert(nextTrack, at: 0)
            }
            .store(in: &cancellable)
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

extension SearchViewModel {
    struct Input {
        let searchButtonTapSubject = PassthroughSubject<String, Never>()
        let backButtonSubject = PassthroughSubject<Void, Never>()
        let selectedTopTrackSubject = PassthroughSubject<TopTracks, Never>()
        let loadTrackSubject = PassthroughSubject<(URL?, AudioPlayer), Never>()
        let isTopTrackLoadSubject = PassthroughSubject<Void, Never>()
        let recentlyPlayedArtistSubject = PassthroughSubject<[ReceivedArtist], Never>()
        let artistInfoSubject = PassthroughSubject<String, Never>()
        let successArtistReceiveSubject = PassthroughSubject<Bool, Never>()
        let nextTrackSubject = PassthroughSubject<String, Never>()
        let albumInfoSubject = PassthroughSubject<String, Never>()
        let successAlbumReceiveSubject = PassthroughSubject<Bool, Never>()
        let albumTitleAndCoverSubject = PassthroughSubject<(String, URL?), Never>()
    }
    
    struct Output {
        var tracks: Track = Track(youtubeVideo: YoutubeVideo(id: "", audio: []), spotifyTrack: SpotifyTrack(trackID: "", name: "", artists: [], album: Album(name: "", shareUrl: URL(string: ""), cover: []), durationMs: 0))
        var artists: [ReceivedArtist] = []
        var selectedArtist: ReceivedArtist?
        var isTrackLoaded: Bool = false
        var playerItem: AVPlayerItem?
        var isTopTrackLoad: Bool = false
        var nextTracksArray: [String] = []
        var selectedAlbum: ReceivedArtistAlbums?
        var albumCover: URL?
        var albumTitle: String?
    }
}
