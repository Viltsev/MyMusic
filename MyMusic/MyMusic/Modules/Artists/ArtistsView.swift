//
//  ArtistsView.swift
//  MyMusic
//
//  Created by Данила on 04.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistsView: View {
    
    @StateObject var viewModel = ArtistsViewModel()
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
                        viewModel.input.selectArtistSubject.send(artist)
                        viewModel.input.sheetButtonSubject.send(.artistView)
                        //showArtist.toggle()
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
//                    .sheet(isPresented: $showArtist) {
//                        if viewModel.output.selectedArtist != nil {
//                            ArtistView(receivedArtist: viewModel.output.selectedArtist!)
//                        }
//                    }
                    Spacer()
                }
                .sheet(item: $viewModel.output.sheet, content: { sheet in
                    switch sheet {
                    case .artistView:
                        if let selectedArtist = viewModel.output.selectedArtist {
                            ArtistView(receivedArtist: selectedArtist)
                        }
                    }
                })
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purpleMid)
    }
}
