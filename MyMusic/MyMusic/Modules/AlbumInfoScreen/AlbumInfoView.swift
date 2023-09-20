//
//  AlbumInfoView.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumInfoView: View {
    @State private var isMPActive = false
    @State private var isLiked = false
    @State private var nextTrackArray: [String] = []
    var albumTitle: String
    var albumCover: URL?
    var receivedAlbum: ReceivedArtistAlbums
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    Text(albumTitle)
                        .font(Font.custom("Chillax-Semibold", size: 30))
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                }
                .padding(.vertical, 50)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .background(
                WebImage(url: albumCover)
                    .resizable()
                    .scaledToFill()
                    .overlay(
                        Color.black.opacity(0.5)
                    )
            )
            .cornerRadius(25)
            Spacer()
            VStack(spacing: 25) {
                Text("Album Tracks")
                    .font(Font.custom("Chillax-Semibold", size: 25))
                    .foregroundColor(Color.greenLight)
                VStack(spacing: 15) {
                    ForEach(receivedAlbum.tracks.items) { track in
                        let artistNames = track.artists.map( { $0.name } )
                        TrackView(isActive: $isMPActive,
                                  nextTrackArray: $nextTrackArray,
                                  trackTitle: track.name,
                                  trackArtists: artistNames.joined(separator: ", "),
                                  trackImage: albumCover,
                                  trackID: track.itemID,
                                  isTopTrack: true
                        )
                    }
                }
            }
            .padding(16)
        }
        .background(Color.purpleMid)
        .ignoresSafeArea()
    }
}
