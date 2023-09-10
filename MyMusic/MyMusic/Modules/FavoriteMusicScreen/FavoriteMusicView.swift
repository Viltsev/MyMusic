//
//  FavoriteMusicView.swift
//  MyMusic
//
//  Created by Данила on 10.09.2023.
//

import SwiftUI

struct FavoriteMusicView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var dataManager: DataManager
    
//    private var mockData: [TopTracks] = [
//        TopTracks(trackID: "", name: "First", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 1", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44") )])),
//        TopTracks(trackID: "", name: "Second", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 2", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "Third", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 3", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "Fourth", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 4", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "Fifth", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 5", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "First", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 1", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44") )])),
//        TopTracks(trackID: "", name: "Second", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 2", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "Third", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 3", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "Fourth", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 4", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))])),
//        TopTracks(trackID: "", name: "Fifth", durationMs: 10000, playCount: 0, artists: [Artist(idArtist: "", name: "Artist 5", shareUrl: nil)], album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))]))
//    ]
    
    @State private var isMPActive = false
    @State private var isLiked = false
    @State private var favoriteTracks: [TrackEntity] = []
    var body: some View {
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
            ScrollView(showsIndicators: false) {
                ForEach(dataManager.savedTrackEntities) { track in
                    if let title = track.trackTitle,
                       let artists = track.trackArtists,
                       let email = UserDefaults.standard.string(forKey: "email"),
                       track.userEmail == email {
                        TrackView(isActive: $isMPActive,
                                  trackTitle: title,
                                  trackArtists: artists,
                                  trackImage: track.trackImage)
                    }
                }
            }
            .onAppear {
//                dataManager.savedTrackEntities.map { track in
//                    if let email = UserDefaults.standard.string(forKey: "email"), track.userEmail == email {
//                        favoriteTracks.append(track)
//                    }
//                }
            }
            .navigationBarBackButtonHidden(true)
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
