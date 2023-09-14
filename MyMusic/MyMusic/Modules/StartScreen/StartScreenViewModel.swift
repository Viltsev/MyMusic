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
    @Published var output = Output()
    let input = Input()
    var cancellable = Set<AnyCancellable>()
    
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
    }
}

extension StartScreenViewModel {
    
    struct Input {
        let sheetButtonSubject = PassthroughSubject<Sheet, Never>()
    }

    struct Output {
        var sheet: Sheet? = nil
    }
    
    enum Sheet: Identifiable {
        case signIn
        case logIn
        
        var id: Int {
            self.hashValue
        }
    }
}

