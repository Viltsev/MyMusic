//
//  TabBarView.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    @StateObject var viewModelTB: TabBarViewModel = TabBarViewModel()
    
    var body: some View {
        TabView {
            Group {
                ContentView()
                    .environmentObject(audioPlayer)
                    .environmentObject(viewModel)
                    .tabItem {
                        Label {
                            Text("Главная")
                        } icon: {
                            Image(systemName: "paperplane")
                        }
                    }
                FavoriteMusicView()
                    .tabItem {
                        Label {
                            Text("Каталог")
                        } icon: {
                            Image(systemName: "folder")
                        }
                    }
            }
            .toolbar(.visible, for: .tabBar)
            .toolbarBackground(Color.purpleMid, for: .tabBar)
        }
        .accentColor(Color.greenLight)
    }
}
