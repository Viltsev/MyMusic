//
//  RecentlyPlayedView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentlyPlayedView: View {
    @EnvironmentObject var dataManager: DataManager
    
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
                ForEach(dataManager.savedArtistsEntities, id: \.id) { artist in
                    if let name = artist.name, let image = artist.image, let id = artist.artistID {
                        Button {
                            
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
                    }
                }
            }
            .padding(25)
        }
    }
}

struct RecentlyPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayedView()
    }
}
