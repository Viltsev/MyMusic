//
//  AppContainer.swift
//  MyMusic
//
//  Created by Данила on 13.09.2023.
//

import SwiftUI
import Swinject

struct AppContainer: View {
    @State private var isAuth = AuthenticationLocalService.shared.status.value
    @State private var isFetchData: Bool = false
    @StateObject private var audioPlayer = AudioPlayer()
    @StateObject private var viewModel = TrackViewModel()
    @StateObject var router = NavigationRouter()

    
    var body: some View {
        Group {
            if isAuth  {
                ContentView()
                    .environmentObject(audioPlayer)
                    .environmentObject(viewModel)
                    .environmentObject(router)
                    .onAppear {
                        viewModel.setAudioPlayer(audioPlayer)
                    }
            } else {
                StartScreenView()
            }
        }
        .onReceive(AuthenticationLocalService.shared.status) { status in
            isAuth = status
        }
    }
}



            
