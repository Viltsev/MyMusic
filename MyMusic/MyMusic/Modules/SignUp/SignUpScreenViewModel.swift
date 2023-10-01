//
//  LogInScreenViewModel.swift
//  MyMusic
//
//  Created by Данила on 08.09.2023.
//

import Foundation
import Combine
import CombineExt
import FirebaseCore
import FirebaseAuth

final class SignUpViewModel: ObservableObject {
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    
    let input: Input = Input()
    @Published var output: Output = Output()
    @Published var errorSignUp: Bool = false
    
    var cancellable = Set<AnyCancellable>()
 
    init() {
        bind()
    }
}

extension SignUpViewModel {
    
    func bind() {
        bindAccessToLogIn()
        logIn()
    }
    
    func bindAccessToLogIn() {
        input.emailSubject
            .combineLatest(input.passwordSubject, input.nameSubject)
            .map { email, password, name in
                !email.isEmpty && !password.isEmpty && !name.isEmpty
            }
            .sink { isEnabledEnter in
                self.output.isDisabledButton = !isEnabledEnter
            }
            .store(in: &cancellable)
    }
    
    func logIn() {
        input.signUpSubject
            .sink { (email, password, name) in
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        self.errorSignUp = true
                        self.output.errorDescription = error?.localizedDescription ?? ""
                    } else {
                        print("Success Log In")
                        self.errorSignUp = false
                        self.output.errorDescription = ""
                        AuthenticationLocalService.shared.status.send(true)
                        self.dataManager.addUser(name: name, email: email)
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "name")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                    }
                }
            }
            .store(in: &cancellable)
    }
    
}

extension SignUpViewModel {
    
    struct Input {
        let nameSubject = PassthroughSubject<String, Never>()
        let emailSubject = PassthroughSubject<String, Never>()
        let passwordSubject = PassthroughSubject<String, Never>()
        let signUpSubject = PassthroughSubject<(String, String, String), Never>()
    }
    
    struct Output {
        var isDisabledButton: Bool = true
        var errorDescription: String = ""
    }
    
}
