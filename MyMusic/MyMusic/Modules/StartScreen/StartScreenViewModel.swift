//
//  StartScreenViewModel.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import Foundation
import Combine
import CombineExt


final class StartScreenViewModel: ObservableObject {
    var router: NavigationRouter? = nil
    
    @Published var output = Output()
    let input = Input()
    var cancellable = Set<AnyCancellable>()
    
    func setRouter(_ router: NavigationRouter) {
        self.router = router
    }
    
    init() {
        bind()
    }
}

extension StartScreenViewModel {
    
    func bind() {
        input.sheetButtonSubject
            .sink { [weak self] in
                switch $0 {
                    case .logIn:
                        self?.output.sheet = .logIn
                    case .signIn:
                        self?.output.sheet = .signIn
                }
            }
            .store(in: &cancellable)
        
        input.popToRoot
            .sink { [weak self] in
                self?.output.isPopToRoot = true
            }
            .store(in: &cancellable)
        
        input.accountCompleteSubject
            .sink { [weak self] in
                self?.output.isAccountComplete = true
            }
            .store(in: &cancellable)
        
        input.signInSuccessSubject
            .sink { [weak self] in
                self?.router?.popToRoot()
            }
            .store(in: &cancellable)
    }
    
    
}

extension StartScreenViewModel {
    
    struct Input {
        let sheetButtonSubject = PassthroughSubject<Sheet, Never>()
        let popToRoot = PassthroughSubject<Void, Never>()
        let accountCompleteSubject = PassthroughSubject<Void, Never>()
        let signInSuccessSubject = PassthroughSubject<Void, Never>()
    }

    struct Output {
        var sheet: Sheet? = nil
        var isPopToRoot: Bool = false
        var isAccountComplete: Bool = false
    }
    
    enum Sheet: Identifiable {
        case signIn
        case logIn
        
        var id: Int {
            self.hashValue
        }
    }
}

