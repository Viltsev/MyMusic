//
//  TrackViewModel.swift
//  MyMusic
//
//  Created by Данила on 10.09.2023.
//

import Foundation
import Combine
import CombineExt
import AVFoundation

final class TrackViewModel: ObservableObject {
    
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    var audioPlayer: AudioPlayer? = nil
    var router: NavigationRouter? = nil
    
    let apiService = GenaralApi()
    let input: Input = Input()
    @Published var output: Output = Output()
    @Published var isLiked: Bool = false
    
    var cancellable = Set<AnyCancellable>()
    
    private var savedTrackEntities: [TrackEntity] {
        return dataManager.fetchTracks()
    }
    
    func setRouter(_ router: NavigationRouter) {
        self.router = router
    }
    
    func setAudioPlayer(_ player: AudioPlayer) {
        self.audioPlayer = player
    }
    
    init() {
        bind()
    }
}

extension TrackViewModel {
    func bind() {
        saveTrack()
        deleteTrack()
        //checkFavoriteTrack()
        bindTrackInfo()
        
        bindSearchButton()
        loadTopTrack()
        loadCurrentTrack()
        saveRecentlyPlayedArtist()
        bindNextTrack()
        bindFullTopTracks()
        bindSelectTopTrack()
        defineFavoriteTrack()
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
    
//    func checkFavoriteTrack() {
//        input.checkFavoriteTrackSubject
//            .sink { trackID in
//                for track in self.savedTrackEntities {
//                    if let currentUser = UserDefaults.standard.string(forKey: "email"),
//                       track.userEmail == currentUser,
//                       let id = track.trackID {
//                        if id == trackID {
//                            self.output.isLiked = true
//                        }
//                    }
//                }
//            }
//            .store(in: &cancellable)
//    }
    
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
    
    func bindFullTopTracks() {
        input.topTrackFullSubject
            .sink { title, artists in
                let trackString = "\(title) \(artists)"
                self.output.topTracksToPlay.append(trackString)
            }
            .store(in: &cancellable)
    }
    
    func bindSelectTopTrack() {
        input.selectTopTrackSubject
            .sink { trackTitle in
                self.output.selectedTopTrack = trackTitle
            }
            .store(in: &cancellable)
    }
    
    func defineFavoriteTrack() {
        input.isFavoriteTrackSubject
            .sink { fetchedTracks, trackID in
                for track in fetchedTracks {
                    if let currentUser = UserDefaults.standard.string(forKey: "email"),
                       track.userEmail == currentUser,
                       let id = track.trackID {
                        if id == trackID {
                            self.isLiked = true
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
        //let checkFavoriteTrackSubject = PassthroughSubject<String, Never>()
        let sheetButtonSubject = PassthroughSubject<Sheet, Never>()
        
        let searchButtonTapSubject = PassthroughSubject<String, Never>()
        let selectedTopTrackSubject = PassthroughSubject<TopTracks, Never>()
        let loadTrackSubject = PassthroughSubject<(URL?, AudioPlayer), Never>()
        let recentlyPlayedArtistSubject = PassthroughSubject<[ReceivedArtist], Never>()
        let nextTrackSubject = PassthroughSubject<String, Never>()
        let topTrackFullSubject = PassthroughSubject<(String, String), Never>()
        let selectTopTrackSubject = PassthroughSubject<String, Never>()
        let isFavoriteTrackSubject = PassthroughSubject<([TrackEntity], String), Never>()
    }
    
    struct Output {
        var isLiked: Bool = false
        var sheet: Sheet? = nil
        
        var tracks: Track = Track(youtubeVideo: YoutubeVideo(id: "", audio: []), spotifyTrack: SpotifyTrack(trackID: "", name: "", artists: [], album: Album(name: "", shareUrl: URL(string: ""), cover: []), durationMs: 0))
        var artists: [ReceivedArtist] = []
        var isTrackLoaded: Bool = false
        var playerItem: AVPlayerItem?
        var nextTracksArray: [String] = []
        var topTracksToPlay: [String] = []
        var selectedTopTrack: String?
    }
    
    enum Sheet: Identifiable {
        case trackInfo

        var id: Int {
            self.hashValue
        }
    }
}
