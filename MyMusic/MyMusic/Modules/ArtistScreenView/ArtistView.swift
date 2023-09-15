//
//  ArtistView.swift
//  MyMusic
//
//  Created by Данила on 04.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistView: View {
    
    @EnvironmentObject var viewModel: SearchViewModel
    
    @State private var isMPActive = false
    @State private var isLiked = false
    
    var receivedArtist: ReceivedArtist
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    Text(receivedArtist.name)
                        .font(Font.custom("Chillax-Semibold", size: 30))
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                    Text("\(receivedArtist.stats.followers) listeners")
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.white)
                }
                .padding(.vertical, 50)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .background(
                WebImage(url: receivedArtist.visuals.avatar.first?.url)
                    .resizable()
                    .scaledToFill()
                    .overlay(
                        Color.black.opacity(0.5)
                    )
            )
            .cornerRadius(25)
            Spacer()
            VStack(spacing: 25) {
                Text("Popular Tracks")
                    .font(Font.custom("Chillax-Semibold", size: 25))
                    .foregroundColor(Color.greenLight)
                VStack(spacing: 15) {
                    ForEach(receivedArtist.discography.topTracks) { track in
                        let artistNames = track.artists.map( { $0.name } )
                        TrackView(isActive: $isMPActive,
                                  trackTitle: track.name,
                                  trackArtists: artistNames.joined(separator: ", "),
                                  trackImage: track.album.cover.first?.url,
                                  trackID: track.trackID
                        )
                    }
                }
                .onAppear {
                    viewModel.input.isTopTrackLoadSubject.send()
                }
            }
            .padding(16)
            VStack(spacing: 25) {
                Text("Albums")
                    .font(Font.custom("Chillax-Semibold", size: 25))
                    .foregroundColor(Color.greenLight)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(receivedArtist.discography.albums.items) { album in
                            if let cover = album.cover.first?.url {
                                Button {
                                    // go to album info
                                } label: {
                                    VStack {
                                        WebImage(url: cover)
                                            .resizable()
                                            .frame(width: 200, height: 200)
                                            .shadow(color: .black.opacity(0.7), radius: 30)
                                            .cornerRadius(20)
                                        Spacer()
                                        VStack {
                                            Text("\(album.name)")
                                                .font(Font.custom("Chillax-Regular", size: 18))
                                                .foregroundColor(Color.white)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                                .frame(width: 200)
                                        }
                                        Spacer()
                                    }
                                    .frame(height: 280)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                }
                //.padding(16)
            }
            
            Spacer()
        }
        .background(Color.purpleMid)
        .ignoresSafeArea()
        
    }
}

