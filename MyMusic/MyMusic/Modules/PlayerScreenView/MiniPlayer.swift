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
    
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var viewModel: SearchViewModel
    
    @State var offset: CGFloat = 0
    @State private var showArtists: Bool = false
    
    @Binding var newTrack: Track
    @Binding var artists: [ReceivedArtist]
    @Binding var expand: Bool
    @Binding var playerItem: AVPlayerItem?
    
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
                                    showArtists.toggle()
                                } label: {
                                    Text(artistNames.joined(separator: ", "))
                                        .font(Font.custom("Chillax-Regular", size: 20))
                                        //.font(.headline)
                                        .foregroundColor(.black)
                                }
                                    .sheet(isPresented: $showArtists) {
                                        ArtistsView(artists: artists)
                                            .presentationDetents([.large, .medium, .fraction(0.75)])
                                    }
                                
                            }
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
                            Image(systemName: "repeat")
                                .font(.title2)
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
                            Image(systemName: "forward.fill")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "heart")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 15)
                        HStack {
                            Spacer()
                            Image(systemName: "text.aligncenter")
                                .font(.title2)
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
//                        if audioPlayer.isPlaying {
//                            audioPlayer.pauseAudio()
//                        } else {
//                            if viewModel.output.isTrackLoaded {
//                                if let unwrappedPlayer = viewModel.output.playerItem {
//                                    audioPlayer.playAudio(from: unwrappedPlayer, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
//                                    viewModel.output.isTrackLoaded.toggle()
//                                }
//                            } else {
//                                if let unwrappedPlayer = viewModel.output.playerItem {
//                                    audioPlayer.playAudio(from: unwrappedPlayer, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
//                                }
//                            }
//
//                        }
                        if audioPlayer.isPlaying {
                            audioPlayer.pauseAudio()
                        } else {
                            if let unwrappedPlayerItem = playerItem {
                                audioPlayer.playAudio(from: unwrappedPlayerItem, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
                            }
                        }
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "stop.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(expand ? 0 : 16)
            Spacer()
        }
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
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.height > 0 && expand {
            offset = value.translation.height
        }
    }
    
    func onEnded(value: DragGesture.Value) {
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

}


/* MOCK DATA
 
 private let mockURL = "https://scd.dlod.link/?expire=1693184542704&p=7Babcu6aZeR3y3s4bIjB6Au1CEpIDh4D8-LZvVjfvcW0wb2e5ykmgb2rGqkUJTNjDuyr3ggeuYg8CyAmMvKqPojhZK09kgHXNyg3UBXin9lNczsTuRXdPVYz4TO7mT9LxHe84Qbz3u-UThYLe4FwW7pZNbII8PNHxNbkK7YcSLYDbTNyghffSlNa1y0izunQ&s=lr49wzblKU86Kq3GrhJGtbFHdSCBKLBvU9OZTzRywHI"
 
 // ---
//                                    if isLoadTrack {
//                                        //viewModel.input.isTrackLoading.send()
//                                        let queue = DispatchQueue(label: "", qos: .background)
//                                        queue.async {
//                                            if let unwrappedAudioURL = newTrack.youtubeVideo.audio.first?.url {
//                                                playerItem = audioPlayer.getTrackURL(from: unwrappedAudioURL)
//                                            }
//                                        }
//                                        isLoadTrack = false
//                                    } else {
//                                        if let unwrappedPlayerItem = playerItem {
//                                            audioPlayer.playAudio(from: unwrappedPlayerItem, totalTime: Double(newTrack.spotifyTrack.durationMs) / 1000)
//                                        }
//                                    }
 // ---
 
 
 
 var mockTrack: Track =
 Track(youtubeVideo: YoutubeVideo(id: "dqdbVlU1f0M", audio: [Audio(url: URL(string: mockURL))]),
       spotifyTrack: SpotifyTrack(name: "MELTDOWN (feat. Drake)",
                                  artists:
                                     [Artist(idArtist: "0Y5tJX1MQlPlqiwlOH1tJY", name: "Travis Scott",
                                             shareUrl: nil),
                                      Artist(idArtist: "3TVXtAsR1Inumwj472S9r4", name: "Drake",
                                             shareUrl: nil)
                                     ],
                                  album: Album(name: "Utopia",
                                               shareUrl: nil,
                                               cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))]), durationMs: 246133))
 
 let mockReceivedArtists: [ReceivedArtist] =
     [
         ReceivedArtist(name: "Travis Scott",
                        stats: Stats(followers: 3000000, worldRank: 5),
                        visuals: Visuals(avatar: [Avatar(url: URL(string: "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9"))]),
                        discography: Discography(topTracks: [
                         TopTracks(trackID: "67nepsnrcZkowTxMWigSbb",
                                   name: "MELTDOWN (feat. Drake)",
                                   durationMs: 246133,
                                   playCount: 117961553,
                                   artists: [Artist(idArtist: "", name: "Travis Scott", shareUrl: nil),
                                            Artist(idArtist: "", name: "Drake", shareUrl: nil)],
                                   album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))]))
                        ])),
         ReceivedArtist(name: "Drake",
                        stats: Stats(followers: 3000000, worldRank: 5),
                        visuals: Visuals(avatar: [Avatar(url: URL(string: "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9"))]),
                        discography: Discography(topTracks: [
                         TopTracks(trackID: "67nepsnrcZkowTxMWigSbb",
                                   name: "MELTDOWN (feat. Drake)",
                                   durationMs: 246133,
                                   playCount: 117961553,
                                   artists: [Artist(idArtist: "", name: "Travis Scott", shareUrl: nil),
                                            Artist(idArtist: "", name: "Drake", shareUrl: nil)],
                                   album: ReceivedAlbum(cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))]))
                        ]))
     ]
 */
