//
//  TrackScreenViewModel.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import Foundation
import Combine
import CombineExt
import UIKit

final class TrackScreenViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension TrackScreenViewModel {
    func bind() {
        bindLoadImage()
        //bindLoadArtistImage()
        //bindLoadTopTracks()
    }
    
    func bindLoadImage() {
        let request = input.loadImageSubject
        request
            .sink { url in
                self.loadImage(sendImage: url)
            }
            .store(in: &cancellable)
    }
    
//    func bindLoadArtistImage() {
//        input.loadArtistCoverSubject
//            .sink { obj in
//                self.loadArtistImage(sendImage: URL(string: obj.0), name: obj.1)
//            }
//            .store(in: &cancellable)
//    }
//
//    func bindLoadTopTracks() {
//        input.loadTopTracksCoversSubject
//            .sink { obj in
//                self.loadTopTracksCovers(sendImage: obj.0, artistName: obj.1, trackTitle: obj.2)
//            }
//            .store(in: &cancellable)
//    }
    
//    func loadArtistImage(sendImage: URL?, name: String) {
//        let queue = DispatchQueue(label: "", qos: .background)
//        queue.async {
//            if let imageURL = sendImage, let mainImageData = try? Data(contentsOf: imageURL) {
//                //self.output.artistCover = UIImage(data: mainImageData)!
//                if let index = self.output.artists.firstIndex(where: { $0.name == name }) {
//                    self.output.artists[index].cover = UIImage(data: mainImageData)!
//                }
//            }
//        }
//    }
    
//    func loadTopTracksCovers(sendImage: URL?, artistName: String, trackTitle: String) {
//        let queue = DispatchQueue(label: "3", qos: .background)
//        queue.async {
//            if let imageURL = sendImage, let imageData = try? Data(contentsOf: imageURL) {
//                //self.output.artistCover = UIImage(data: mainImageData)!
//                if let index = self.output.artists.firstIndex(where: { $0.name == artistName }) {
//                    if let trackIndex = self.output.artists[index].discography.topTracks.firstIndex(where: { $0.name == trackTitle}) {
//                        self.output.artists[index].discography.topTracks[trackIndex].trackCover = UIImage(data: imageData)!
//                    }
//                }
//            }
//        }
//    }
    
    func loadImage(sendImage: URL?) {
        let queue = DispatchQueue(label: "", qos: .background)
        queue.async {
            if let imageURL = sendImage, let mainImageData = try? Data(contentsOf: imageURL) {
                self.output.trackCover = UIImage(data: mainImageData)!
            }
        }
    }
    
}

extension TrackScreenViewModel {
    struct Input {
        let loadImageSubject = PassthroughSubject<URL?, Never>()
        let loadArtistCoverSubject = PassthroughSubject<(String, String), Never>()
        let loadTopTracksCoversSubject = PassthroughSubject<(URL?, String, String), Never>()
    }
    struct Output {
        var trackCover: UIImage?
        var artistCover: UIImage?
        var artists: [ReceivedArtist] = [
            ReceivedArtist(artistID: "", name: "Travis Scott",
                           stats: Stats(followers: 3000000, worldRank: 5),
                           visuals: Visuals(avatar: [Avatar(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))]),
                           discography: Discography(topTracks: [
                            TopTracks(trackID: "67nepsnrcZkowTxMWigSbb",
                                      name: "MELTDOWN (feat. Drake)",
                                      durationMs: 246133,
                                      playCount: 117961553,
                                      artists: [Artist(idArtist: "", name: "Travis Scott", shareUrl: nil),
                                               Artist(idArtist: "", name: "Drake", shareUrl: nil)],
                                      album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])
                                     )
                           ])
                          ),
            ReceivedArtist(artistID: "", name: "Drake",
                           stats: Stats(followers: 5000000, worldRank: 5),
                           visuals: Visuals(avatar: [Avatar(url: URL(string: "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9"))]),
                           discography: Discography(topTracks: [
                            TopTracks(trackID: "67nepsnrcZkowTxMWigSbb",
                                      name: "MELTDOWN (feat. Drake)",
                                      durationMs: 246133,
                                      playCount: 117961553,
                                      artists: [Artist(idArtist: "", name: "Travis Scott", shareUrl: nil),
                                               Artist(idArtist: "", name: "Drake", shareUrl: nil)],
                                      album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])
                                     ),
                            TopTracks(trackID: "3F5CgOj3wFlRv51JsHbxhe",
                                      name: "Jimmy Cooks (feat. 21 Savage)",
                                      durationMs: 218364,
                                      playCount: 117961553,
                                      artists: [Artist(idArtist: "", name: "Drake", shareUrl: nil),
                                               Artist(idArtist: "", name: "21 Savage", shareUrl: nil)],
                                      album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e028dc0d801766a5aa6a33cbe37"))])
                                     ),
                            TopTracks(trackID: "",
                                      name: "One Dance",
                                      durationMs: 218364,
                                      playCount: 117961553,
                                      artists: [Artist(idArtist: "", name: "Drake", shareUrl: nil),
                                               Artist(idArtist: "", name: "Wizkid", shareUrl: nil),
                                               Artist(idArtist: "", name: "Kyla", shareUrl: nil)],
                                      album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e029416ed64daf84936d89e671c"))])
                                     ),
                            TopTracks(trackID: "",
                                      name: "Rich Flex",
                                      durationMs: 218364,
                                      playCount: 117961553,
                                      artists: [Artist(idArtist: "", name: "Drake", shareUrl: nil),
                                               Artist(idArtist: "", name: "21 Savage", shareUrl: nil)],
                                      album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e0202854a7060fccc1a66a4b5ad"))])
                                     ),
                            TopTracks(trackID: "",
                                      name: "God's Plan",
                                      durationMs: 218364,
                                      playCount: 117961553,
                                      artists: [Artist(idArtist: "", name: "Drake", shareUrl: nil)],
                                      album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02f907de96b9a4fbc04accc0d5"))])
                                     )
                           ])
                        )
        ]
    }
}

