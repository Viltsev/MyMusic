//
//  LyricsView.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import SwiftUI

struct LyricsView: View {

    var trackTitle: String
    var trackArtists: String
    var receivedLyrics: TrackText
    
    var body: some View {
        VStack {
            Text(trackTitle)
                .font(Font.custom("Chillax-Semibold", size: 35))
                .foregroundColor(Color.greenLight)
                .padding(25)
            Text(trackArtists)
                .font(Font.custom("Chillax-Semibold", size: 25))
                .foregroundColor(Color.greenLight)
            ScrollView(showsIndicators: false) {
                ForEach(receivedLyrics.lyrics.lines) { words in
                    HStack {
                        Text(words.words)
                            .font(Font.custom("Chillax-Regular", size: 15))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .frame(width: 350)
                }
            }
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.purpleMid)
    }
}

//struct LyricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LyricsView()
//    }
//}
