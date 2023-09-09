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

final class LogInViewModel: ObservableObject {
    
    var router: NavigationRouter? = nil
    var dataBase: DataManager? = nil
    
    var successLogIn: AnyPublisher<Bool, Never> {
        return input.successLogInSubject.eraseToAnyPublisher()
    }
    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    func setRouter(_ router: NavigationRouter) {
        self.router = router
    }
    
    func setDataBase(_ database: DataManager) {
        self.dataBase = database
    }
 
    init() {
        bind()
    }
}

extension LogInViewModel {
    
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
        input.logInSubject
            .sink { (email, password, name) in
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    } else {
                        print("Success Log In")
                        self.input.successLogInSubject.send(true)
                        self.dataBase?.addUser(name: name, email: email)
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

extension LogInViewModel {
    
    struct Input {
        let nameSubject = PassthroughSubject<String, Never>()
        let emailSubject = PassthroughSubject<String, Never>()
        let passwordSubject = PassthroughSubject<String, Never>()
        let logInSubject = PassthroughSubject<(String, String, String), Never>()
        let successLogInSubject = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var isDisabledButton: Bool = true
    }
    
}
