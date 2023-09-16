//
//  GeneralAPI.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import Foundation
import Combine
import CombineMoya

struct GenaralApi {
    let provider = Provider<GeneralEndpoint>()
    let artistProvider = Provider<ReceiveArtistEndpoint>()
    let albumProvider = Provider<ReceiveAlbumEndpoint>()
}

extension GenaralApi {
    
    func getTrack(byName track: String) -> AnyPublisher<Track, ErrorAPI> {
        provider.requestPublisher(.getTrack(track: track))
            .filterSuccessfulStatusCodes()
            .map(ServerTrack.self)
            .map {
                TrackModelMapper().toLocal(serverEntity: $0)
            }
            .mapError { error in
                if error.response?.statusCode == 404 {
                    return ErrorAPI.notFound
                } else {
                    return ErrorAPI.network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func receiveArtist(byID id: String) -> AnyPublisher<ReceivedArtist, ErrorAPI> {
        artistProvider.requestPublisher(.receiveArtist(id: id))
            .filterSuccessfulStatusCodes()
            .map(ServerReceivedArtist.self)
            .map {
                ReceivedArtistModelMapper().toLocal(serverEntity: $0)
            }
            .mapError { error in
                if error.response?.statusCode == 404 {
                    return ErrorAPI.notFound
                } else {
                    return ErrorAPI.network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func receiveAlbum(byID id: String) -> AnyPublisher<ReceivedArtistAlbums, ErrorAPI> {
        albumProvider.requestPublisher(.receiveAlbum(id: id))
            .filterSuccessfulStatusCodes()
            .map(ServerReceivedArtistAlbums.self)
            .map {
                ReceivedArtistAlbumsMapper().toLocal(serverEntity: $0)
            }
            .mapError { error in
                if error.response?.statusCode == 404 {
                    return ErrorAPI.notFound
                } else {
                    return ErrorAPI.network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
