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
                    .font(Font.custom("Bakery Holland", size: 40))
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
//                        AsyncImage(url: artist.visuals.avatar.first?.url) { phase in
//                            switch phase {
//                                case .empty:
//                                    ProgressView()
//                                case .success(let image):
//                                    image
//                                        .resizable()
//                                        .frame(width: 50, height: 50)
//                                        .cornerRadius(25)
//                                        .padding(.horizontal, 16)
//                                case .failure(_):
//                                    Text("Failed to load image")
//                                @unknown default:
//                                    EmptyView()
//                            }
//                        }
                        Text(artist.name)
                            .font(.title2)
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
