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
    @Published var savedTrackEntities: [TrackEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "UsersContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("error loading core data. \(error)")
            }
        }
        fetchUsers()
        fetchTracks()
    }
    
    func fetchUsers() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
        
    }
    
    func fetchTracks() {
        let request = NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
        do {
            savedTrackEntities = try container.viewContext.fetch(request)
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
    
    func addTrack(user: UserEntity, trackTitle: String, trackArtists: String, trackCover: URL) {
        let newTrack = TrackEntity(context: container.viewContext)
        newTrack.trackTitle = trackTitle
        newTrack.trackArtists = trackArtists
        newTrack.trackImage = trackCover
        newTrack.userEmail = user.email
        newTrack.id = UUID()
        
        saveTrackData()
//        savedTrackEntities.append(newTrack)
//        user.tracks = savedTrackEntities as NSObject
//
//        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchUsers()
        } catch let error {
            print("error saving. \(error)")
        }
        
    }
    
    func saveTrackData() {
        do {
            try container.viewContext.save()
            fetchTracks()
        } catch let error {
            print("error saving. \(error)")
        }
    }
    
}
