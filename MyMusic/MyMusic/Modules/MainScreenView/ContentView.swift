//
//  ContentView.swift
//  MyMusic
//
//  Created by Данила on 19.08.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject var router = NavigationRouter()
    @StateObject var startViewModel = StartScreenViewModel()
    
    @State var show = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack {
                        SearchBarView(show: $show)
                            .environmentObject(router)
                        RecommendationsCircleView()
                        FavoriteTracksView()
                        RecentlyPlayedView()
                        Spacer()
                    }
                    
                    Button {
                        self.show.toggle()
                    } label: {
                        if startViewModel.output.isAccountComplete {
                            ProfileView()
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 1.1)
                    .background(Color.purpleMid)
                    .cornerRadius(30)
                    .offset(x: show ? 0 : -UIScreen.main.bounds.width)
                    .rotation3DEffect(Angle(degrees: show ? 0 : 30), axis: (x: 0, y: 10.0, z: 0))
                    .animation(.easeInOut(duration: 0.3))
                    .padding(.trailing, 80)
                    .shadow(color: .black, radius: 30)
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
