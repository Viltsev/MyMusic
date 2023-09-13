//
//  MainCoordinator.swift
//  MyMusic
//
//  Created by Данила on 13.09.2023.
//

import Foundation
import Combine

final class AuthenticationLocalService {
    
    let status = CurrentValueSubject<Bool, Never>(UserStorage.shared.authStatus)
    static var shared = AuthenticationLocalService()
    var cancellable = Set<AnyCancellable>()
    
    private init() {
        status
            .sink { value in
                UserStorage.shared.authStatus = value
            }
            .store(in: &cancellable)
    }
}
