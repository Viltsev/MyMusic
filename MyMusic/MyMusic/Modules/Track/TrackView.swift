//
//  TrackView.swift
//  MyMusic
//
//  Created by Данила on 06.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrackView: View {
    private let dataManager = AppAssembler.resolve(DataProtocol.self)

    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var viewModel: TrackViewModel
    @StateObject var trackViewModel = TrackViewModel()
    @Binding var isActive: Bool
    @State var isLiked: Bool = false
    
    var trackTitle: String
    var trackArtists: String
    var trackImage: URL?
    var trackID: String
    var isTopTrack: Bool
    
    private var savedTrackEntities: [TrackEntity] {
        return dataManager.fetchTracks()
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                playTrack()
            } label: {
                WebImage(url: trackImage)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.7), radius: 30)
                    .cornerRadius(15)
                    
                VStack(alignment: .leading, spacing: 10) {
                    Text(trackTitle)
                        .font(Font.custom("Chillax-Semibold", size: 18))
                        .lineLimit(0)
                        .foregroundColor(Color.white)
                    Text(trackArtists)
                        .font(Font.custom("Chillax-Regular", size: 15))
                        .foregroundColor(Color.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            HStack {
                Button {
                    addToFavorite()
                } label: {
                    ZStack {
                        image(Image(systemName: "heart.fill"), show: isLiked)
                        image(Image(systemName: "heart"), show: !isLiked)
                    }
                    .onReceive(trackViewModel.$isLiked) { isLiked in
                        self.isLiked = isLiked
                    }
                }
                Button {
                    trackViewModel.input.sheetButtonSubject.send(.trackInfo)
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title)
                        .foregroundColor(Color.white)
                }
            }
            .sheet(item: $trackViewModel.output.sheet, content: { sheet in
                switch sheet {
                    case .trackInfo:
                    TrackInfoView(trackTitle: trackTitle,
                                  trackArtists: trackArtists,
                                  trackImage: trackImage,
                                  trackID: trackID
                    )
                        .environmentObject(viewModel)
                        .presentationDetents([.large, .large, .fraction(0.75)])
                }
            })
            
        }
        .onAppear {
            trackViewModel.input.isFavoriteTrackSubject.send((savedTrackEntities, trackID))
        }
        .padding(25)
    }
    
}

extension TrackView {
    private func playTrack() {
        if isTopTrack {
            viewModel.input.selectTopTrackSubject.send("\(trackTitle) \(trackArtists)")
            viewModel.input.searchButtonTapSubject.send(viewModel.output.selectedTopTrack!)
        }
        isActive.toggle()
        if audioPlayer.isPlaying {
            audioPlayer.pauseAudio()
        }
        audioPlayer.restartAudio(newTrack: true)
    }
    
    private func addToFavorite() {
        if isLiked {
            print("delete: \(trackTitle)")
            viewModel.input.deleteTrackSubject.send(trackID)
            isLiked.toggle()
        } else {
            isLiked.toggle()
            viewModel.input.saveTrackSubject.send((trackTitle, trackArtists, trackImage, trackID))
        }
    }
    
    private func image(_ image: Image, show: Bool) -> some View {
        image
            .tint(isLiked ? Color.greenLight : Color.white)
            .font(.title)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
    }
}
