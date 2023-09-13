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
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
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
                        print("Success Sign In")
                        AuthenticationLocalService.shared.status.send(true)
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "name")
                        UserDefaults.standard.set(email, forKey: "email")
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
    }
    
    struct Output {
        var isDisabledButton: Bool = true
    }
    
}
