//
//  Assembly.swift
//  MyMusic
//
//  Created by Данила on 14.09.2023.
//

import Foundation
import Swinject

extension Assembler {
    static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler(
            [ServiceAssembly()],
            container: container
        )
        return assembler
    }()
}

struct AppAssembler {
    private static var resolver = Assembler.shared.resolver
    
    static func resolve<T>(_ type: T.Type) -> T {
        resolver.resolve(type)!
    }
}
