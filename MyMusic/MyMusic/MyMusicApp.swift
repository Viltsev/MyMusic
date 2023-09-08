//
//  MyMusicApp.swift
//  MyMusic
//
//  Created by Данила on 19.08.2023.
//

import SwiftUI
import AVFoundation
import SDWebImage

@main
struct MyMusicApp: App {
    
    //@StateObject var router = NavigationRouter()
    @StateObject private var audioPlayer = AudioPlayer()
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioPlayer)
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.setAudioPlayer(audioPlayer)
                }
        }
    }
    
}
