//
//  ArtistsView.swift
//  MyMusic
//
//  Created by Данила on 04.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistsView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    
    @StateObject var viewModelTrack = TrackScreenViewModel()
    @StateObject var viewModelArtist = ArtistsViewModel()
    
    @State private var showArtist: Bool = false
    
    var artists: [ReceivedArtist]
    
    var body: some View {
        VStack {
            HStack {
                Text("Artists")
                    .font(Font.custom("Chillax-Semibold", size: 25))
                    .foregroundColor(Color.greenLight)
            }.padding(25)
            ForEach(artists) { artist in
                HStack {
                    Button {
                        viewModelArtist.input.selectArtistSubject.send(artist)
                        showArtist.toggle()
                    } label: {
                        WebImage(url: artist.visuals.avatar.first?.url)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)
                            .padding(.horizontal, 16)
                        Text(artist.name)
                            .font(Font.custom("Chillax-Regular", size: 20))
                            .foregroundColor(Color.white)
                    }
                    .sheet(isPresented: $showArtist) {
                        if viewModelArtist.output.selectedArtist != nil {
                            ArtistView(receivedArtist: viewModelArtist.output.selectedArtist!)
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purpleMid)
    }
}
