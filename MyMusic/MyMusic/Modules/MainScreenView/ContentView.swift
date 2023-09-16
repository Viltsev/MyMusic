//
//  ContentView.swift
//  MyMusic
//
//  Created by Данила on 19.08.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    @EnvironmentObject var router: NavigationRouter
    
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
                            .environmentObject(router)
                        RecentlyPlayedView()
                            .environmentObject(viewModel)
                        Spacer()
                    }
                    Button {
                        self.show.toggle()
                    } label: {
                        ProfileView()
                            .environmentObject(router)
                    }
                    .frame(height: UIScreen.main.bounds.height / 1.1)
                    .background(Color.greenLight)
                    .cornerRadius(30)
                    .offset(x: show ? 0 : -UIScreen.main.bounds.width)
                    .rotation3DEffect(Angle(degrees: show ? 0 : 30), axis: (x: 0, y: 10.0, z: 0))
                    .animation(.easeInOut(duration: 0.3))
                    .padding(.trailing, 80)
                    .shadow(color: .black, radius: 30)
                }
                
            }
            .background(Color.purpleMid)
            .navigationDestination(for: Navigation.self) { nav in
                Group {
                    switch nav {
                    case .pushSearchScreen:
                        SearchView()
                    case .pushFavoriteMusic:
                        FavoriteMusicView()
                            .environmentObject(viewModel)
                    }
                }
                .environmentObject(router)
            }
        }
    }
}
