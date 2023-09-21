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
    }
}
