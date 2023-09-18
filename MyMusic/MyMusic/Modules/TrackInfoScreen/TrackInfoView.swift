//
//  TrackInfoView.swift
//  MyMusic
//
//  Created by Данила on 15.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrackInfoView: View {
    
    @EnvironmentObject var viewModel: SearchViewModel
    @StateObject var viewModelTrack = TrackInfoViewModel()
    @State private var showLyrics: Bool = false
    var trackTitle: String
    var trackArtists: String
    var trackImage: URL?
    var trackID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                WebImage(url: trackImage)
                    .resizable()
                    .frame(width: 75, height: 75)
                    .cornerRadius(20)
                VStack(spacing: 15) {
                    HStack {
                        Text(trackTitle)
                            .font(Font.custom("Chillax-Regular", size: 20))
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .lineLimit(0)
                        Spacer()
                    }
                    HStack {
                        Text("\(trackArtists)")
                            .font(Font.custom("Chillax-Regular", size: 15))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.vertical, 35)
            .padding(.horizontal, 25)
            Button {
                viewModel.input.nextTrackSubject.send("\(trackTitle) \(trackArtists)")
            } label: {
                HStack(spacing: 25) {
                    Image(systemName: "arrow.turn.right.down")
                        .font(.title)
                        .foregroundColor(Color.greenLight)
                    Text("Play Next")
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.greenLight)
                }
                .padding(25)
            }
            Button {
                // show artists action
            } label: {
                HStack(spacing: 21) {
                    Image(systemName: "music.mic")
                        .font(.title)
                        .foregroundColor(Color.greenLight)
                    Text("Go to artists")
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.greenLight)
                }
                .padding(25)
            }
            Button {
                // show album action
            } label: {
                HStack(spacing: 23) {
                    Image(systemName: "record.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.greenLight)
                    Text("Go to album")
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.greenLight)
                }
                .padding(25)
            }
            Button {
                viewModelTrack.input.lyricsTrackSubject.send(trackID)
            } label: {
                HStack(spacing: 22) {
                    Image(systemName: "music.note.list")
                        .font(.title)
                        .foregroundColor(Color.greenLight)
                    Text("Show lyrics")
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.greenLight)
                }
                .padding(25)
            }
            .sheet(isPresented: $showLyrics) {
                if viewModelTrack.output.lyrics != nil {
                    LyricsView(trackTitle: trackTitle,
                               trackArtists: trackArtists,
                               receivedLyrics: viewModelTrack.output.lyrics!)
                }
            }
            Spacer()
        }
        .onReceive(viewModelTrack.successLyricsReceive, perform: { success in
            if success {
                showLyrics.toggle()
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purpleDark)
    }
}
