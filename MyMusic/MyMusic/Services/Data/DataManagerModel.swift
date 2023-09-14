//
//  DataManagerModel.swift
//  MyMusic
//
//  Created by Данила on 13.09.2023.
//

import Foundation
import Combine
import CombineExt


final class DataManagerModel: ObservableObject {
    
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    //private var dataManager: DataManager
    //Injection.shared.container.resolve(DataProtocol.self)!
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    var successArtistReceive: AnyPublisher<Bool, Never> {
        return input.successArtistReceiveSubject.eraseToAnyPublisher()
    }
    
    
    init() {
        bind()
    }
}

extension DataManagerModel {
    func bind() {
        input.fetchDataSubject
            .sink { _ in
//                if let savedUserEntities = self.dataManager.fetchUsers(),
//                   let savedTrackEntities = self.dataManager.fetchTracks(),
//                   let savedArtistsEntities = self.dataManager.fetchArtists() {
                    self.output.savedUserEntities = self.dataManager.fetchUsers()
                    self.output.savedTrackEntities = self.dataManager.fetchTracks()
                    self.output.savedArtistsEntities = self.dataManager.fetchArtists()
                    self.input.successArtistReceiveSubject.send(true)
                //}
//                if let savedUserEntities = self.output.savedUserEntities, !savedUserEntities.isEmpty {
//                    self.input.successArtistReceiveSubject.send(true)
//                }
            }
            .store(in: &cancellable)
    }
}

extension DataManagerModel {
    struct Input {
        let fetchDataSubject = PassthroughSubject<Void, Never>()
        let successArtistReceiveSubject = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var savedUserEntities: [UserEntity] = []
        var savedTrackEntities: [TrackEntity] = []
        var savedArtistsEntities: [ArtistEntity] = []
    }
}



            
    
