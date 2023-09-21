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
    
    @StateObject var viewModelArtist = ArtistsViewModel()
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
                    if isLiked {
                        print("delete: \(trackTitle)")
                        trackViewModel.input.deleteTrackSubject.send(trackID)
                        isLiked.toggle()
                    } else {
                        isLiked.toggle()
                        trackViewModel.input.saveTrackSubject.send((trackTitle, trackArtists, trackImage, trackID))
                    }
                } label: {
                    ZStack {
                        image(Image(systemName: "heart.fill"), show: isLiked)
                        image(Image(systemName: "heart"), show: !isLiked)
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
            isFavoriteTrack()
        }
        .padding(25)
    }
    
    func image(_ image: Image, show: Bool) -> some View {
        image
            .tint(isLiked ? Color.greenLight : Color.white)
            .font(.title)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
    }
    
    private func isFavoriteTrack() {
        for track in savedTrackEntities {
            if let currentUser = UserDefaults.standard.string(forKey: "email"),
               track.userEmail == currentUser,
               let id = track.trackID {
                if id == trackID {
                    self.isLiked = true
                }
            }
        }
    }
}

extension TrackView {
    private func playTrack() {
        if isTopTrack {
            viewModelArtist.input.selectTopTrackSubject.send("\(trackTitle) \(trackArtists)")
            viewModel.input.searchButtonTapSubject.send(viewModelArtist.output.selectedTopTrack!)
            if isActive {
                isActive.toggle()
            }
        }
        isActive.toggle()
        if audioPlayer.isPlaying {
            audioPlayer.pauseAudio()
        }
        audioPlayer.restartAudio(newTrack: true)
    }
}
