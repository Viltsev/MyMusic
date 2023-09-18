//
//  RecentlyPlayedView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentlyPlayedView: View {
    
    private let dataManager = AppAssembler.resolve(DataProtocol.self)
    @StateObject var viewModel = RecentlyPlayedViewModel()
    
    @State private var showArtist: Bool = false
    
    private var savedArtistEntities: [ArtistEntity] {
        return dataManager.fetchArtists()
    }
    
    var body: some View {
        HStack {
            Text(.recentlyPlayed)
                .font(Font.custom("Chillax-Semibold", size: 25))
                .foregroundColor(Color.greenLight)
                .padding(.horizontal, 25)
            Spacer()
        }
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(savedArtistEntities, id: \.id) { artist in
                    if let name = artist.name, let image = artist.image, let id = artist.artistID {
                        Button {
                            viewModel.input.artistInfoSubject.send(id)
                        } label: {
                            VStack {
                                WebImage(url: image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .shadow(color: .black.opacity(0.7), radius: 30)
                                    .cornerRadius(75)
                                Text(name)
                                    .font(Font.custom("Chillax-Regular", size: 20))
                                    .foregroundColor(Color.white)
                            }
                        }
                        .sheet(isPresented: $showArtist) {
                            if viewModel.output.selectedArtist != nil {
                                ArtistView(receivedArtist: viewModel.output.selectedArtist!)
                            }
                        }
                    }
                }
            }
            .onReceive(viewModel.successArtistReceive, perform: { success in
                if success {
                    showArtist.toggle()
                }
            })
            .padding(25)
        }
    }
}

struct RecentlyPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayedView()
    }
}
