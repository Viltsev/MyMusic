//
//  DataManager.swift
//  MyMusic
//
//  Created by Данила on 09.09.2023.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [UserEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "UsersContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("error loading core data. \(error)")
            }
        }
        fetchUsers()
    }
    
    func fetchUsers() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
        
    }
    
    func addUser(name: String, email: String) {
        let newUser = UserEntity(context: container.viewContext)
        newUser.name = name
        newUser.email = email
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchUsers()
        } catch let error {
            print("error saving. \(error)")
        }
        
    }
    
}
