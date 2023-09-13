//
//  AppContainer.swift
//  MyMusic
//
//  Created by Данила on 13.09.2023.
//

import SwiftUI

struct AppContainer: View {
    
    @State private var isAuth = AuthenticationLocalService.shared.status.value
    @StateObject private var audioPlayer = AudioPlayer()
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var dataManager = DataManager()
    @StateObject var router = NavigationRouter()
    @StateObject var startViewModel = StartScreenViewModel()
    
    var body: some View {
        Group {
            if isAuth {
                ContentView()
                    .environmentObject(audioPlayer)
                    .environmentObject(viewModel)
                    .environmentObject(dataManager)
                    .environmentObject(router)
                    .onAppear {
                        viewModel.setAudioPlayer(audioPlayer)
                        viewModel.setDataManager(dataManager)
                    }
            } else {
                StartScreenView()
                    .environmentObject(startViewModel)
                    .environmentObject(dataManager)
            }
        }
        .onReceive(AuthenticationLocalService.shared.status) { status in
            isAuth = status
        }
    }
}



            
