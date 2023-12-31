//
//  FavoriteTracksView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI

struct FavoriteTracksView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        HStack {
            Text(.favoriteTracks)
                .font(Font.custom("Chillax-Semibold", size: 25))
                .foregroundColor(Color.greenLight)
                .padding(.horizontal, 25)
            Spacer()
        }
        Button {
            router.pushView(Navigation.pushFavoriteMusic)
        } label: {
            HStack(spacing: 25) {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.greenLight)
                    .cornerRadius(20)
                Text(.likeTracks)
                    .font(Font.custom("Chillax-Regular", size: 20))
                    .foregroundColor(Color.white)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.title2)
                    .foregroundColor(Color.greenLight)
            }.padding(25)
        }
    }
}

struct FavoriteTracksView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTracksView()
    }
}
