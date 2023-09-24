//
//  DataManager.swift
//  MyMusic
//
//  Created by Данила on 09.09.2023.
//

import Foundation
import CoreData

protocol DataProtocol {
    func fetchUsers() -> [UserEntity]
    func fetchTracks() -> [TrackEntity]
    func fetchArtists() -> [ArtistEntity]
    func addArtist(name: String, cover: URL, artistID: String)
    func addUser(name: String, email: String)
    func addTrack(trackTitle: String, trackArtists: String, trackCover: URL, trackID: String)
    func deleteTrack(trackID: String)
    func deleteArtist(artistID: String)
}

class DataManager: DataProtocol {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "UsersContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("error loading core data. \(error)")
            }
        }
    }
    
    func fetchUsers() -> [UserEntity] {
        var savedEntities: [UserEntity] = []
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
        return savedEntities
    }
    
    func fetchTracks() -> [TrackEntity] {
        var savedTrackEntities: [TrackEntity] = []
        let request = NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
        do {
            savedTrackEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
        return savedTrackEntities
    }
    
    func fetchArtists() -> [ArtistEntity] {
        var savedArtistsEntities: [ArtistEntity] = []
        let request = NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
        do {
            savedArtistsEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching. \(error)")
        }
        return savedArtistsEntities
    }
    
    func addArtist(name: String, cover: URL, artistID: String) {
        let newArtist = ArtistEntity(context: container.viewContext)
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        let artistRequest = NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            request.predicate = NSPredicate(format: "email == %@", email)
        }
        artistRequest.predicate = NSPredicate(format: "artistID == %@", artistID)
        
        let savedArtistsEntities = fetchArtists()
        
        do {
            if savedArtistsEntities.contains(where: { artist in
                artist.artistID == artistID
            }) {
                print("artist already has been added!")
            } else {
                if let currentUser = try container.viewContext.fetch(request).first {
                    newArtist.name = name
                    newArtist.image = cover
                    newArtist.userEmail = currentUser.email
                    newArtist.artistID = artistID
                    newArtist.id = UUID()
                    
                    saveArtistData()
                }
            }
        } catch let error {
            print("error adding track. \(error)")
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
    
    func deleteArtist(artistID: String) {
        let request = NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
        request.predicate = NSPredicate(format: "artistID == %@", artistID)
        
        do {
            if let artistToDelete = try container.viewContext.fetch(request).first {
                container.viewContext.delete(artistToDelete)
                saveArtistData()
            }
        } catch let error {
            print("error deleting track. \(error)")
        }
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving. \(error)")
        }
        
    }
    
    private func saveTrackData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving. \(error)")
        }
    }
    
    private func saveArtistData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving. \(error)")
        }
    }
    
}
