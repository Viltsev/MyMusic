//
//  ServiceAssembly.swift
//  MyMusic
//
//  Created by Данила on 14.09.2023.
//

import Foundation
import Swinject

struct ServiceAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(DataProtocol.self) { _ in
            return DataManager()
        }.inObjectScope(.container)
        
        container.register(DataManagerModel.self) { _ in
            return DataManagerModel()
        }.inObjectScope(.container)
        
        container.register(AudioPlayer.self) { _ in
            return AudioPlayer()
        }.inObjectScope(.container)
    }
}
