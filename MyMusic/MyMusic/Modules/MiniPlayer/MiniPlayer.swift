//
//  MiniPlayer.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import SwiftUI
import AVFoundation
import SDWebImageSwiftUI


struct MiniPlayer: View {
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var viewModel: TrackViewModel
    
    @StateObject var viewModelTrackInfo = TrackInfoViewModel()
    @StateObject var miniPlayerViewModel = MiniPlayerViewModel()
    
    @State var offset: CGFloat = 0
    @State var isLiked: Bool = false
    
    @Binding var newTrack: Track
    @Binding var artists: [ReceivedArtist]
    @Binding var expand: Bool
    
    private var savedTrackEntities: [TrackEntity] {
        return dataManager.fetchTracks()
    }
    
    var height = UIScreen.main.bounds.height / 3
    
    var body: some View {
        let artistNames = newTrack.spotifyTrack.artists.map { $0.name }
        VStack {
            if !expand {
                Spacer()
            }
            HStack(spacing: 20) {
                VStack {
                }
                .frame(maxWidth: expand ? .infinity : nil)
                .frame(width: expand ? nil : 55)
                .frame(height: expand ? 500 : 55)
                .background(
                    WebImage(url: newTrack.spotifyTrack.album.cover.first?.url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(newTrack.spotifyTrack.name)
                                .font(Font.custom("Chillax-Semibold", size: 30))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            VStack {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.body.weight(.bold))
                                        .foregroundColor(.secondary)
                                        .padding(8)
                                        .background(.ultraThinMaterial, in: Circle())
                                }
                                .padding(-21)
                            }
                        }
                        Divider()
                        HStack {
                            VStack {
                                Button {
                                    miniPlayerViewModel.input.sheetButtonSubject.send(.artistsView)
                                } label: {
                                    Text(artistNames.joined(separator: ", "))
                                        .font(Font.custom("Chillax-Regular", size: 20))
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .sheet(item: $miniPlayerViewModel.output.sheet, content: { sheet in
                                switch sheet {
                                case .artistsView:
                                    ArtistsView(artists: artists)
                                        .presentationDetents([.large, .medium, .fraction(0.75)])
                                }
                            })
                        }
                        VStack(spacing: 5) {
                            Slider(value: $audioPlayer.currentTimeSliderValue, in: 0...Double(newTrack.spotifyTrack.durationMs) / 1000, step: 1.0, onEditingChanged: { editing in
                                if !editing {
                                    audioPlayer.seekTo(time: audioPlayer.currentTimeSliderValue)
                               }
                            })
                            .tint(Color.greenLight)
                            HStack {
                                Text("\(formatTime(audioPlayer.currentTimeSliderValue))")
                                    .font(Font.custom("Chillax-Regular", size: 18))
                                Spacer()
                                Text("\(formatTime(Double(newTrack.spotifyTrack.durationMs) / 1000))")
                                    .font(Font.custom("Chillax-Regular", size: 18))
                            }
                        }
                        .padding(.vertical, 30)
                        HStack(spacing: 25) {
                            Button {
                                miniPlayerViewModel.input.repeatTrackSubject.send()
                            } label: {
                                Image(systemName: "repeat")
                                    .font(.title2)
                                    .foregroundColor(miniPlayerViewModel.output.repeatTrack ? Color.greenLight : Color.black)
                            }
                            Spacer()
                            Button {
                                if audioPlayer.isPlaying {
                                    audioPlayer.restartAudio(newTrack: false)
                                } else {
                                    audioPlayer.isPlaying.toggle()
                                    audioPlayer.restartAudio(newTrack: false)
                                }
                                
                            } label: {
                                Image(systemName: "backward.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                            Button {
                                if audioPlayer.isPlaying {
                                    audioPlayer.pauseAudio()
                                } else {
                                    if viewModel.output.isTrackLoaded {
                                        if let unwrappedPlayer = viewModel.output.playerItem {
                                            audioPlayer.playAudio(from: unwrappedPlayer, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
                                            viewModel.output.isTrackLoaded.toggle()
                                        }
                                    } else {
                                        if let unwrappedPlayer = viewModel.output.playerItem {
                                            audioPlayer.playAudio(from: unwrappedPlayer, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: audioPlayer.isPlaying ? "stop.fill" : "play.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                            }
                            Button {
                                audioPlayer.pauseAudio()
                                if !viewModel.output.nextTracksArray.isEmpty {
                                    let nextTrack = viewModel.output.nextTracksArray[0]
                                    viewModel.input.searchButtonTapSubject.send(nextTrack)
                                    viewModel.output.nextTracksArray.removeFirst()
                                    audioPlayer.restartAudio(newTrack: true)
                                } else if !viewModel.output.topTracksToPlay.isEmpty {
                                    viewModel.output.topTracksToPlay.removeFirst()
                                    let nextTrack = viewModel.output.topTracksToPlay[0]
                                    viewModel.input.searchButtonTapSubject.send(nextTrack)
                                    audioPlayer.restartAudio(newTrack: true)
                                }
                            } label: {
                                Image(systemName: "forward.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            Button {
                                if isLiked {
                                    viewModel.input.deleteTrackSubject.send(newTrack.spotifyTrack.trackID)
                                    isLiked.toggle()
                                } else {
                                    let artistNames = newTrack.spotifyTrack.artists.map { $0.name }
                                    let trackImage = newTrack.spotifyTrack.album.cover.first?.url
                                    viewModel.input.saveTrackSubject.send((newTrack.spotifyTrack.name, artistNames.joined(separator: ", "), trackImage, newTrack.spotifyTrack.trackID))
                                    isLiked.toggle()
                                }
                            } label:
                            {
                                ZStack {
                                    image(Image(systemName: "heart.fill"), show: isLiked)
                                    image(Image(systemName: "heart"), show: !isLiked)
                                }
                            }
                        }
                        .padding(.vertical, 15)
                        HStack {
                            Spacer()
                            Button {
                                viewModelTrackInfo.input.lyricsTrackSubject.send(newTrack.spotifyTrack.trackID)
                            } label: {
                                Image(systemName: "text.aligncenter")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                            .sheet(item: $viewModelTrackInfo.output.sheet, content: { sheet in
                                switch sheet {
                                case .trackInfo:
                                    if let lyrics = viewModelTrackInfo.output.lyrics {
                                        LyricsView(trackTitle: newTrack.spotifyTrack.name,
                                                   trackArtists: artistNames.joined(separator: ", "),
                                                   receivedLyrics: lyrics)
                                    }
                                }
                            })
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    )
                    .offset(y: 350)
                    .padding(20)
                )
                if !expand {
                    Text(newTrack.spotifyTrack.name)
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        if audioPlayer.isPlaying {
                            audioPlayer.pauseAudio()
                        } else {
                            if viewModel.output.isTrackLoaded {
                                if let unwrappedPlayer = viewModel.output.playerItem {
                                    audioPlayer.playAudio(from: unwrappedPlayer, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
                                    viewModel.output.isTrackLoaded.toggle()
                                }
                            } else {
                                if let unwrappedPlayer = viewModel.output.playerItem {
                                    audioPlayer.playAudio(from: unwrappedPlayer, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
                                }
                            }

                        }
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "stop.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Button {
                        if isLiked {
                            viewModel.input.deleteTrackSubject.send(newTrack.spotifyTrack.trackID)
                            isLiked.toggle()
                        } else {
                            let artistNames = newTrack.spotifyTrack.artists.map { $0.name }
                            let trackImage = newTrack.spotifyTrack.album.cover.first?.url
                            viewModel.input.saveTrackSubject.send((newTrack.spotifyTrack.name, artistNames.joined(separator: ", "), trackImage, newTrack.spotifyTrack.trackID))
                            isLiked.toggle()
                        }
                    } label:
                    {
                        ZStack {
                            image(Image(systemName: "heart.fill"), show: isLiked)
                            image(Image(systemName: "heart"), show: !isLiked)
                        }
                        .onReceive(miniPlayerViewModel.$isLiked) { isLiked in
                            self.isLiked = isLiked
                        }
                    }
                }
            }
            .padding(expand ? 0 : 16)
            Spacer()
        }
        .onAppear {
            miniPlayerViewModel.input.isFavoriteTrackSubject.send((savedTrackEntities, newTrack.spotifyTrack.trackID))
        }
        .onReceive(audioPlayer.isTrackEnded, perform: { result in
            if result {
                trackEndedAction()
            }
        })
        .frame(maxWidth: expand ? .infinity : nil, maxHeight: expand ? .infinity : 80)
        .background(
            VStack(spacing: 0) {
                BlurView()
                Divider()
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    expand = true
                }
            }
        )
        .cornerRadius(expand ? 20 : 0)
        .offset(y: expand ? 0 : -48)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onEnded(value: )).onChanged(onChanged(value: )))
        .ignoresSafeArea()
    }
}

extension MiniPlayer {
    private func onChanged(value: DragGesture.Value) {
        if value.translation.height > 0 && expand {
            offset = value.translation.height
        }
    }
    
    private func onEnded(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > height {
                expand = false
            }
            offset = 0
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func image(_ image: Image, show: Bool) -> some View {
        image
            .tint(isLiked ? Color.greenLight : Color.black)
            .font(.title)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
    }
    
    private func trackEndedAction() {
        if miniPlayerViewModel.output.repeatTrack {
            audioPlayer.restartAudio(newTrack: false)
        } else {
            audioPlayer.pauseAudio()
            if !viewModel.output.nextTracksArray.isEmpty {
                let nextTrack = viewModel.output.nextTracksArray[0]
                viewModel.input.searchButtonTapSubject.send(nextTrack)
                viewModel.output.nextTracksArray.removeFirst()
                audioPlayer.restartAudio(newTrack: true)
            } else if !viewModel.output.topTracksToPlay.isEmpty {
                viewModel.output.topTracksToPlay.removeFirst()
                let nextTrack = viewModel.output.topTracksToPlay[0]
                viewModel.input.searchButtonTapSubject.send(nextTrack)
                audioPlayer.restartAudio(newTrack: true)
            }
        }
    }
}
