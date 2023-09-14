//
//  UserStorage.swift
//  MyMusic
//
//  Created by Данила on 13.09.2023.
//

import Foundation

enum UserStorageKey: String {
    case authStatus
}


struct UserStorage {
    
    private let userDefaults = UserDefaults.standard
    
    static var shared = UserStorage()
    
    private init() {}
    
    var authStatus: Bool {
        get {
            userDefaults.bool(forKey: UserStorageKey.authStatus.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserStorageKey.authStatus.rawValue)
        }
    }
}
