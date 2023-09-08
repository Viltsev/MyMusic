//
//  SignInViewModel.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import Foundation
import Combine
import CombineExt

final class SignInViewModel: ObservableObject {
    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension SignInViewModel {
    
    func bind() {
        input.emailSubject
            .combineLatest(input.passwordSubject)
            .map { email, password in
                !email.isEmpty && !password.isEmpty
            }
            .sink { isEnabledEnter in
                self.output.isDisabledButton = !isEnabledEnter
            }
            .store(in: &cancellable)
    }
    
}

extension SignInViewModel {
    
    struct Input {
        let emailSubject = PassthroughSubject<String, Never>()
        let passwordSubject = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var isDisabledButton: Bool = true
    }
    
}
