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
    
    func addTrack(trackTitle: String, trackArtists: String, trackCover: URL, trackID: String) {
        let newTrack = TrackEntity(context: container.viewContext)
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        if let email = UserDefaults.standard.string(forKey: "email") {
            request.predicate = NSPredicate(format: "email == %@", email)
        }
        
        do {
            if let currentUser = try container.viewContext.fetch(request).first {
                newTrack.trackTitle = trackTitle
                newTrack.trackArtists = trackArtists
                newTrack.trackImage = trackCover
                newTrack.userEmail = currentUser.email
                newTrack.trackID = trackID
                newTrack.id = UUID()
                
                saveTrackData()
            }
        } catch let error {
            print("error adding track. \(error)")
        }
    }
    
    func deleteTrack(trackID: String) {
        let request = NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
        request.predicate = NSPredicate(format: "trackID == %@", trackID)
        
        do {
            if let trackToDelete = try container.viewContext.fetch(request).first {
                container.viewContext.delete(trackToDelete)
                saveTrackData()
            }
        } catch let error {
            print("error deleting track. \(error)")
        }
    }
    
//    func isFavoriteTrack(_ trackID: String) -> Bool {
//        let request = NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
//        request.predicate = NSPredicate(format: "trackID == %@", trackID)
//
//        do {
//            if let track = try container.viewContext.fetch(request).first {
//                return true
//            } else {
//                return false
//            }
//        } catch let error {
//            print("error searching track. \(error)")
//            return false
//        }
//    }
    
    
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
