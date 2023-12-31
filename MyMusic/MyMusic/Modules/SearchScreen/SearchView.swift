//
//  SearchView.swift
//  MyMusic
//
//  Created by Данила on 23.08.2023.
//

import SwiftUI
import AVFoundation

struct SearchView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var viewModel: TrackViewModel
    @EnvironmentObject var audioPlayer: AudioPlayer
    @Environment(\.dismiss) var dismiss
    
    @State private var trackName: String = ""
    @State private var isMPActive = false
    @State var expand = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            ScrollView(showsIndicators: false) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .foregroundColor(Color.greenLight)
                    }
                    SearchField(text: $trackName, fieldSize: 15, isPassword: false, isEmail: false)
                    Spacer()
                    Button {
                        playSearchedTrack()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(Color.greenLight)
                    }
                }
                .padding(25)
                VStack {
                    if !viewModel.output.tracks.spotifyTrack.name.isEmpty {
                        let artistNames = viewModel.output.tracks.spotifyTrack.artists.map { $0.name }
                            TrackView(
                                isActive: $isMPActive,
                                trackTitle: viewModel.output.tracks.spotifyTrack.name,
                                trackArtists: artistNames.joined(separator: ", "),
                                trackImage: viewModel.output.tracks.spotifyTrack.album.cover.first?.url,
                                trackID: viewModel.output.tracks.spotifyTrack.trackID,
                                isTopTrack: false
                            )
                    }
                }
            }
            .background(Color.purpleMid)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.setRouter(router)
            }
            
            if viewModel.output.tracks.spotifyTrack.album.cover.first?.url != nil {
                MiniPlayer(
                    newTrack: $viewModel.output.tracks,
                    artists: $viewModel.output.artists,
                    expand: $expand
                )
                    .opacity(isMPActive ? 0 : 1)
            }
            
        }
    }
    
}

struct LikeTrackView: View {
    @State var isLiked: Bool
    var body: some View {
        Button {
            print("like!")
        } label: {
            if isLiked {
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundColor(.white)
            } else {
                Image(systemName: "heart")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SearchField: View {
    @Binding var text: String
    var fieldSize: Int
    var isPassword: Bool
    var isEmail: Bool
    
    var body: some View {
        HStack {
            if isPassword {
                SecureField("Search...", text: $text)
                    .font(Font.custom("Chillax-Regular", size: CGFloat(fieldSize)))
                    .foregroundColor(Color.white)
                    .disableAutocorrection(true)
            } else {
                if isEmail {
                    TextField("Search...", value: $text, formatter: LowerCaseStringFormatter())
                        .font(Font.custom("Chillax-Regular", size: CGFloat(fieldSize)))
                        .foregroundColor(Color.white)
                        .disableAutocorrection(true)
                }
                else {
                    TextField("Search...", text: $text)
                        .font(Font.custom("Chillax-Regular", size: CGFloat(fieldSize)))
                        .foregroundColor(Color.white)
                        .disableAutocorrection(true)
                }
            }
        }.modifier(customViewModifier(roundedCornes: 25, textColor: Color.white))
    }
}

struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding(10)
            .cornerRadius(roundedCornes)
            .foregroundColor(textColor)
            .textCase(.lowercase)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                .stroke(Color.greenLight))
            .padding(.horizontal, 16)
    }
}

extension SearchView {
    private func playSearchedTrack() {
        if audioPlayer.isPlaying {
            viewModel.input.nextTrackSubject.send(self.trackName)
        } else {
            viewModel.input.searchButtonTapSubject.send(self.trackName)
            if isMPActive {
                isMPActive.toggle()
            }
        }
    }
}
