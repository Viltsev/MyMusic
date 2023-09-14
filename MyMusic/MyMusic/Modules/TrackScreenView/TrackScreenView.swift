//
//  TrackScreenView.swift
//  MyMusic
//
//  Created by Данила on 26.08.2023.
//

//import SwiftUI
//import AVFoundation
//
//private let mockURL = "https://scd.dlod.link/?expire=1693184542704&p=7Babcu6aZeR3y3s4bIjB6Au1CEpIDh4D8-LZvVjfvcW0wb2e5ykmgb2rGqkUJTNjDuyr3ggeuYg8CyAmMvKqPojhZK09kgHXNyg3UBXin9lNczsTuRXdPVYz4TO7mT9LxHe84Qbz3u-UThYLe4FwW7pZNbII8PNHxNbkK7YcSLYDbTNyghffSlNa1y0izunQ&s=lr49wzblKU86Kq3GrhJGtbFHdSCBKLBvU9OZTzRywHI"
//
////https://soundcloud-result.s3.amazonaws.com/2023-08-26/1693077644332.mp3
////https://scd.dlod.link/?expire=1693152355261&p=40QC5uv9WbO_offSKiHmqB5mC3lGJR5wNNm5X-nZurMAdDW_JgIaeJPw1uuBoq4XkMffJTnch8MIIyoM-_UK158UwcXkLWsQPllcqlBVY8utLKrxlz2YrsLt0XbA5At6dAD96_W7Afhz9gLqZYY9pvHrfP8oEjpJ8ldLUEu9Yqxi6iWVw0ezNDEvc90PR2r0&s=zrzSzj4k5VtjBg0BlfK1C297tsV7b956GN-J5vKc1F4
//
//struct TrackScreenView: View {
//    
//    var mockTrack: Track =
//    Track(youtubeVideo: YoutubeVideo(id: "dqdbVlU1f0M", audio: [Audio(url: URL(string: mockURL))]),
//          spotifyTrack: SpotifyTrack(trackID: "", name: "MELTDOWN (feat. Drake)",
//                                     artists:
//                                        [Artist(idArtist: "0Y5tJX1MQlPlqiwlOH1tJY", name: "Travis Scott",
//                                                shareUrl: nil),
//                                         Artist(idArtist: "3TVXtAsR1Inumwj472S9r4", name: "Drake",
//                                                shareUrl: nil)
//                                        ],
//                                     album: Album(name: "Utopia",
//                                                  shareUrl: nil,
//                                                  cover: [Cover(url: URL(string: "https://i.scdn.co/image/ab67616d00001e02881d8d8378cd01099babcd44"))]), durationMs: 246133))
//    
//    var body: some View {
//        VStack {
//            TrackCovew(trackTitle: mockTrack.spotifyTrack.name, trackArtists: mockTrack.spotifyTrack.artists, mockTrackImage: mockTrack.spotifyTrack.album.cover[0].url, mockAudio: mockTrack.youtubeVideo.audio[0].url, totalTime: Double(mockTrack.spotifyTrack.durationMs) / 1000)
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.purpleMid)
//        .ignoresSafeArea()
//    }
//    
//}
//
//struct TrackCovew: View {
//    @StateObject var viewModel = TrackScreenViewModel()
//    
//    @State private var uiImage: UIImage?
//    @State var trackTitle: String
//    @State var trackArtists: [Artist]
//    @State var mockTrackImage: URL?
//    @State var mockAudio: URL?
//    @State var totalTime: Double
//    
//    @State private var currentTime: Double = 0.0
//    
//    @State private var playerItem: AVPlayerItem?
//    @StateObject var audioPlayer = AudioPlayer()
//    
//    var body: some View {
//        let artistNames = trackArtists.map { $0.name }
//        
//        VStack {
//            if let uiImage = viewModel.output.trackCover {
//                VStack {
//                }
//                .frame(maxWidth: .infinity)
//                .frame(height: 500)
//                .background(
//                    Image(uiImage: uiImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                )
//                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
//                .overlay(
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack {
//                            Text(trackTitle)
//                                .font(.largeTitle.weight(.bold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            VStack {
//                                Button {
//                                    
//                                } label: {
//                                    Image(systemName: "xmark")
//                                        .font(.body.weight(.bold))
//                                        .foregroundColor(.secondary)
//                                        .padding(8)
//                                        .background(.ultraThinMaterial, in: Circle())
//                                }
//                                .padding(-21)
//                            }
//                        }
//                        Divider()
//                        HStack {
//                            VStack {
//                                Text(artistNames.joined(separator: ", "))
//                                    .font(.headline)
//                            }
//                        }
//                        VStack(spacing: 5) {
//                            Slider(value: $audioPlayer.currentTimeSliderValue, in: 0...totalTime, step: 1.0, onEditingChanged: { editing in
//                                if !editing {
//                                    audioPlayer.seekTo(time: audioPlayer.currentTimeSliderValue)
//                               }
//                            })
//                            .tint(Color.greenLight)
//                            HStack {
//                                Text("\(formatTime(audioPlayer.currentTimeSliderValue))")
//                                Spacer()
//                                Text("\(formatTime(totalTime))")
//                            }
//                        }
//                        .onAppear {
//                            if let unwrappedAudioURL = mockAudio {
//                                playerItem = audioPlayer.getTrackURL(from: unwrappedAudioURL)
//                            }
//                        }
//                        .padding(.vertical, 30)
//                        HStack(spacing: 25) {
//                            Image(systemName: "repeat")
//                                .font(.title2)
//                            Spacer()
//                            Button {
//                                if audioPlayer.isPlaying {
//                                    audioPlayer.restartAudio(newTrack: false)
//                                } else {
//                                    audioPlayer.isPlaying.toggle()
//                                    audioPlayer.restartAudio(newTrack: false)
//                                }
//                                
//                            } label: {
//                                Image(systemName: "backward.fill")
//                                    .font(.title2)
//                                    .foregroundColor(.black)
//                            }
//                            Button {
//                                if audioPlayer.isPlaying {
//                                    audioPlayer.pauseAudio()
//                                } else {
//                                    if let unwrappedPlayerItem = playerItem {
//                                        audioPlayer.playAudio(from: unwrappedPlayerItem, totalTime: totalTime)
//                                    }
//                                }
//                            } label: {
//                                Image(systemName: audioPlayer.isPlaying ? "stop.fill" : "play.fill")
//                                    .font(.largeTitle)
//                                    .foregroundColor(.black)
//                            }
//                            Image(systemName: "forward.fill")
//                                .font(.title2)
//                            Spacer()
//                            Image(systemName: "heart")
//                                .font(.title)
//                                .foregroundColor(.black)
//                        }
//                        .padding(.vertical, 15)
//                        HStack {
//                            Spacer()
//                            Image(systemName: "text.aligncenter")
//                                .font(.title2)
//                            Spacer()
//                        }
//                    }
//                    .padding(20)
//                    .background(
//                        Rectangle()
//                            .fill(.ultraThinMaterial)
//                            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
//                    )
//                    .offset(y: 350)
//                    .padding(20)
//                )
//            }
//        }
//        .onAppear {
//            viewModel.input.loadImageSubject.send(mockTrackImage)
//        }
//    }
//    
//    private func formatTime(_ time: Double) -> String {
//        let minutes = Int(time) / 60
//        let seconds = Int(time) % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
//}
//
//struct TrackScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackScreenView()
//    }
//}


