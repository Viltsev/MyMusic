//
//  BaseModelMapper.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import Foundation

class BaseModelMapper<S, L> {
    
    func toLocal(list: [S]?) -> [L] {
        guard let list = list else { return [] }
        return list.compactMap { $0 }
            .map { entity -> L in
            return toLocal(serverEntity: entity)
        }
    }

    func toLocal(serverEntity: S) -> L {
        preconditionFailure("This method must be overriden")
    }
}
