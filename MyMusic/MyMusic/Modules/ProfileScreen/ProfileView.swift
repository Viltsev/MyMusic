//
//  ProfileView.swift
//  MyMusic
//
//  Created by Данила on 09.09.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: SearchViewModel
    @EnvironmentObject var audioPlayer: AudioPlayer
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    
    private var savedEntities: [UserEntity] {
        return dataManager.fetchUsers()
    }
    
    private var name: String {
        var name = ""
        for user in savedEntities {
            if let email = UserDefaults.standard.string(forKey: "email"), user.email == email {
                name = user.name ?? ""
            }
        }
        return name
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(name)
                    .font(Font.custom("Chillax-Regular", size: 20))
            }
            .foregroundColor(Color.purpleDark)
            HStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .resizable()
                    .frame(width: 20, height: 15)
                Text(UserDefaults.standard.string(forKey: "email") ?? "")
                    .font(Font.custom("Chillax-Regular", size: 20))
            }
            .foregroundColor(Color.purpleDark)
            Button {
                router.pushView(Navigation.pushFavoriteMusic)
            } label: {
                HStack(spacing: 20) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Favorite Tracks")
                        .font(Font.custom("Chillax-Regular", size: 20))
                }
            }
            .foregroundColor(Color.purpleDark)
            Button {
                viewModel.output.tracks = Track(youtubeVideo: YoutubeVideo(id: "", audio: []), spotifyTrack: SpotifyTrack(trackID: "", name: "", artists: [], album: Album(name: "", shareUrl: URL(string: ""), cover: []), durationMs: 0))
                audioPlayer.pauseAudio()
                AuthenticationLocalService.shared.status.send(false)
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "name")
            } label: {
                HStack(spacing: 20) {
                    Image(systemName: "arrow.uturn.down")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Sign Out")
                        .font(Font.custom("Chillax-Regular", size: 20))
                }
            }.foregroundColor(Color.purpleDark)
            Spacer()
        }
        .padding(25)
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
