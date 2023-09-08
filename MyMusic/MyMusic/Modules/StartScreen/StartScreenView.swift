//
//  StartScreenView.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import SwiftUI

struct StartScreenView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var startViewModel: StartScreenViewModel
    
    @State private var signIn: Bool = false
    @State private var logIn: Bool = false
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            VStack {
                Text(.myMusic)
                    .font(Font.custom("Bakery Holland", size: 60))
                    .foregroundColor(Color.greenLight)
                Button {
                    router.pushView(Navigation.pushSignInScreen)
                    //startViewModel.input.sheetButtonSubject.send(.signIn)
                } label: {
                    VStack {
                        Text("Sign In")
                            .font(Font.custom("Bakery Holland", size: 40))
                            .foregroundColor(Color.greenLight)
                    }
                    .frame(width: 200, height: 70)
                    .background(Color.purpleMid)
                    .cornerRadius(30)
                    .shadow(color: .black, radius: 10)
                    .padding(25)
                    
                }
                Button {
                    router.pushView(Navigation.pushLogInScreen)
                    //startViewModel.input.sheetButtonSubject.send(.logIn)
                } label: {
                    VStack {
                        Text("Log In")
                            .font(Font.custom("Bakery Holland", size: 40))
                            .foregroundColor(Color.greenLight)
                    }
                    .frame(width: 200, height: 70)
                    .background(Color.purpleMid)
                    .cornerRadius(30)
                    .shadow(color: .black, radius: 10)
                }
            }
            .sheet(item: $startViewModel.output.sheet, content: { sheet in
                switch sheet {
                case .signIn:
                    SignInScreenView()
                        //.environmentObject(router)
                case .logIn:
                    LogInScreenView()
                        //.environmentObject(router)
                }
            })
            .frame(width: screenWidth / 1.2, height: screenHeight / 1.3)
            .background(Color.purpleMid)
            .cornerRadius(20)
            .shadow(color: .black, radius: 30)
            .onAppear {
                startViewModel.setRouter(router)
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(width: screenWidth, height: screenHeight)
        .background(Color.purpleDark.ignoresSafeArea(.all))
    }
}

struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView()
            .background(Color.purpleDark)
            .ignoresSafeArea()
    }
}

/*
 
 
 
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
     }.background(Color.purpleMid)
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
     }
 }
 
 
 */
