//
//  MyMusicApp.swift
//  MyMusic
//
//  Created by Данила on 19.08.2023.
//

import SwiftUI
import AVFoundation
import SDWebImage
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct MyMusicApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
