//
//  ContentView.swift
//  MyMusic
//
//  Created by Данила on 19.08.2023.
//

import SwiftUI

struct ContentView: View {    
    @StateObject var router = NavigationRouter()
    @StateObject var startViewModel = StartScreenViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView(showsIndicators: false) {
                VStack {
                    SearchBarView()
                        .environmentObject(router)
                    RecommendationsCircleView()
                    FavoriteTracksView()
                    RecentlyPlayedView()
                    Spacer()
                }
            }
            .onAppear {
                if !startViewModel.output.isAccountComplete {
                    router.pushView(Navigation.pushStartScreen)
                }
            }
            .background(Color.purpleMid)
            .navigationDestination(for: Navigation.self) { nav in
                Group {
                    switch nav {
                    case .pushSearchScreen:
                        SearchView()
                    case .pushProfileScreen:
                        Text("")
                    case .pushSignInScreen:
                        SignInScreenView()
                    case .pushLogInScreen:
                        LogInScreenView()
                    case .pushMainScreen:
                        ContentView()
                    case .pushStartScreen:
                        StartScreenView()
                    }
                }
                .environmentObject(router)
                .environmentObject(startViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
