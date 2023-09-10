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
//                AsyncImage(url: receivedArtist.visuals.avatar.first?.url) { phase in
//                    switch phase {
//                        case .empty:
//                            ProgressView()
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                        case .failure(_):
//                            Text("Failed to load image")
//                        @unknown default:
//                            EmptyView()
//                    }
//                }
            )
            .cornerRadius(25)
            Spacer()
            VStack(spacing: 25) {
                Text("Popular Tracks")
                    .font(Font.custom("Chillax-Semibold", size: 25))
                    .foregroundColor(Color.greenLight)
                VStack(spacing: 15) {
                    ForEach(receivedArtist.discography.topTracks) { track in
                        let artistNames = track.artists.map({$0.name})
                        TrackView(isActive: $isMPActive,
                                  trackTitle: track.name,
                                  trackArtists: artistNames.joined(separator: ", "),
                                  trackImage: track.album.cover.first?.url
                        )
                    }
                }
                .onAppear {
                    viewModel.input.isTopTrackLoadSubject.send()
                }
            }
            .padding(16)
        }
        .background(Color.purpleMid)
        .ignoresSafeArea()
        
    }
}

