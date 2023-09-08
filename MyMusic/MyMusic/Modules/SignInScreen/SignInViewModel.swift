//
//  SignInViewModel.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import Foundation
import Combine
import CombineExt
import FirebaseCore
import FirebaseAuth

final class SignInViewModel: ObservableObject {
    
    var router: NavigationRouter? = nil
    
    var successSignIn: AnyPublisher<Bool, Never> {
        return input.successSignInSubject.eraseToAnyPublisher()
    }
    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    func setRouter(_ router: NavigationRouter) {
        self.router = router
    }
    
    init() {
        bind()
    }
}

extension SignInViewModel {
    
    func bind() {
        bindAccessToSignIn()
        signIn()
    }
    
    func bindAccessToSignIn() {
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
    
    func signIn() {
        input.signInSubject
            .sink { (email, password) in
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    } else {
                        print("success")
                        self.input.successSignInSubject.send(true)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
}

extension SignInViewModel {
    
    struct Input {
        let emailSubject = PassthroughSubject<String, Never>()
        let passwordSubject = PassthroughSubject<String, Never>()
        let signInSubject = PassthroughSubject<(String, String), Never>()
        let successSignInSubject = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var isDisabledButton: Bool = true
    }
    
}
