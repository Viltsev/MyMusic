//
//  TrackView.swift
//  MyMusic
//
//  Created by Данила on 06.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrackView: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var viewModel: SearchViewModel
    
    @StateObject var viewModelArtist = ArtistsViewModel()
    
    @Binding var isActive: Bool
    
    var trackTitle: String
    var trackArtists: [Artist]
    var trackImage: URL?
    
    var body: some View {
        let artistNames = trackArtists.map { $0.name }
        HStack(spacing: 20) {
            Button {
                if viewModel.output.isTopTrackLoad {
                    viewModelArtist.input.selectTopTrackSubject.send("\(trackTitle) \(trackArtists.first!.name)")
                    viewModel.input.searchButtonTapSubject.send(viewModelArtist.output.selectedTopTrack!)
                    if isActive {
                        isActive.toggle()
                    }
                    viewModel.input.isTopTrackLoadSubject.send()
                }
                isActive.toggle()
                audioPlayer.pauseAudio()
                audioPlayer.restartAudio(newTrack: true)
            } label: {
                WebImage(url: trackImage)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.7), radius: 30)
                    .cornerRadius(15)
//                AsyncImage(url: trackImage) { phase in
//                    switch phase {
//                        case .empty:
//                            ProgressView()
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .frame(width: 70, height: 70)
//                                .shadow(color: .black.opacity(0.7), radius: 30)
//                                .cornerRadius(15)
//                        case .failure(_):
//                            Text("Failed to load image")
//                        @unknown default:
//                            EmptyView()
//                    }
//                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(trackTitle)
                        .font(.title3)
                        .lineLimit(0)
                        .foregroundColor(Color.white)
                    Text(artistNames.joined(separator: ", "))
                        .font(.headline)
                        .foregroundColor(Color.gray)
                }
                Spacer()
            }
            LikeTrackView(isLiked: false)
        }
        .padding(25)
    }
    
    
}
