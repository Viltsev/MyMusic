//
//  StartScreenView.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import SwiftUI

struct StartScreenView: View {
    @EnvironmentObject var startViewModel: StartScreenViewModel
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
            VStack {
                VStack {
                    Text(.myMusic)
                        .font(Font.custom("Chillax-Semibold", size: 45))
                        .foregroundColor(Color.greenLight)
                    Button {
                        startViewModel.input.sheetButtonSubject.send(.signIn)
                    } label: {
                        VStack {
                            Text("Sign In")
                                .font(Font.custom("Chillax-Semibold", size: 25))
                                .foregroundColor(Color.greenLight)
                        }
                        .frame(width: 200, height: 70)
                        .background(Color.purpleMid)
                        .cornerRadius(30)
                        .shadow(color: .black, radius: 10)
                        .padding(25)
                        
                    }
                    Button {
                        startViewModel.input.sheetButtonSubject.send(.logIn)
                    } label: {
                        VStack {
                            Text("Log In")
                                .font(Font.custom("Chillax-Semibold", size: 25))
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
                    case .logIn:
                        LogInScreenView()
                    }
                })
                .frame(width: screenWidth / 1.2, height: screenHeight / 1.3)
                .background(Color.purpleMid)
                .cornerRadius(20)
                .shadow(color: .black, radius: 30)
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
