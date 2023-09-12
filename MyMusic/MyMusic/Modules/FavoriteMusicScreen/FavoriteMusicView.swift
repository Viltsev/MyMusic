//
//  FavoriteMusicView.swift
//  MyMusic
//
//  Created by Данила on 10.09.2023.
//

import SwiftUI
import AVFoundation

struct FavoriteMusicView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var viewModel: SearchViewModel
    @State private var playerItem: AVPlayerItem?
    @State private var isMPActive = false
    @State private var isLiked = false
    @State private var favoriteTracks: [TrackEntity] = []
    @State var expand = false
    
    var body: some View {
        //alignment: Alignment(horizontal: .center, vertical: .bottom)
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            VStack {
                HStack {
                    Button {
                        router.popToRoot()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .foregroundColor(Color.greenLight)
                    }
                    Spacer()
                    Text("Favorite Tracks")
                        .font(Font.custom("Chillax-Semibold", size: 30))
                        .foregroundColor(Color.greenLight)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(Color.greenLight)
                    }
                }
                .padding(25)
                Button {
                    
                } label: {
                    VStack {
                        HStack(spacing: 20) {
                            Image(systemName: "play.fill")
                                .font(.title2)
                                .foregroundColor(Color.purpleDark)
                            Text("Listen")
                                .font(Font.custom("Chillax-Regular", size: 25))
                                .foregroundColor(Color.purpleDark)
                        }
                    }
                    .frame(width: 280, height: 60)
                    .background(Color.greenLight)
                    .cornerRadius(30)
                }
                VStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(dataManager.savedTrackEntities) { track in
                            if let title = track.trackTitle,
                               let artists = track.trackArtists,
                               let email = UserDefaults.standard.string(forKey: "email"),
                               track.userEmail == email,
                               let id = track.trackID {
                                TrackView(isActive: $isMPActive,
                                          trackTitle: title,
                                          trackArtists: artists,
                                          trackImage: track.trackImage,
                                          trackID: id
                                )
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 1.8)
                    .onAppear {
                        viewModel.input.isTopTrackLoadSubject.send()
                    }
                }
                .navigationBarBackButtonHidden(true)
                Spacer()
            }
            
            
            if viewModel.output.tracks.spotifyTrack.album.cover.first?.url != nil  {
                Spacer()
                VStack {
                    MiniPlayer(
                        newTrack: $viewModel.output.tracks,
                        artists: $viewModel.output.artists,
                        expand: $expand,
                        playerItem: $playerItem
                    )
                }
                
                    //.opacity(isMPActive ? 0 : 1)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.purpleMid)
    }
}

struct FavoriteMusicView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMusicView()
    }
}
