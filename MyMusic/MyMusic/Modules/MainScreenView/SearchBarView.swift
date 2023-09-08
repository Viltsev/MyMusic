//
//  SearchBarView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        HStack {
            Button {
                //router.pushView(Navigation.pushProfileScreen)
            } label: {
                Image(systemName: "text.alignleft")
                    .font(.title2)
                    .foregroundColor(Color.greenLight)
            }
            Spacer()
            Text(.myMusic)
                .font(Font.custom("Bakery Holland", size: 40))
                .foregroundColor(Color.greenLight)
            Spacer()
            Button {
                router.pushView(Navigation.pushSearchScreen)
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(Color.greenLight)
            }
        }
        .padding(25)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
