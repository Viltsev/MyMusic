//
//  SignInScreenView.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import SwiftUI

struct SignInScreenView: View {
    
    @EnvironmentObject var router: NavigationRouter
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var startViewModel: StartScreenViewModel
    
    @StateObject var signViewModel = SignInViewModel()

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isHidePassword = true
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    router.popToRoot()
                } label: {
                    Text("back")
                        .font(Font.custom("Chillax-Semibold", size: 20))
                        .foregroundColor(Color.greenLight)
                        
                }
                .padding(.horizontal, -50)
                Text("Sign In")
                    .font(Font.custom("Chillax-Semibold", size: 45))
                    .foregroundColor(Color.greenLight)
                    .padding(25)
            }
            VStack(alignment: .leading, spacing: -10) {
                Text("Email")
                    .font(Font.custom("Chillax-Semibold", size: 20))
                    .foregroundColor(Color.greenLight)
                    .padding(.horizontal, 60)
                SearchField(text: $email,
                            fieldSize: 25,
                            isPassword: false,
                            isEmail: true)
                .onChange(of: email, perform: bindEmail)
                    .padding(25)
            }
            VStack(alignment: .leading, spacing: -10) {
                HStack {
                    Text("Password")
                        .font(Font.custom("Chillax-Semibold", size: 20))
                        .foregroundColor(Color.greenLight)
                        .padding(.horizontal, 60)
                    Spacer()
                    Button {
                        isHidePassword.toggle()
                    } label: {
                        if isHidePassword {
                            Text("show")
                                .font(Font.custom("Chillax-Semibold", size: 15))
                                .foregroundColor(Color.greenLight)
                        } else {
                            Text("hide")
                                .font(Font.custom("Chillax-Semibold", size: 15))
                                .foregroundColor(Color.greenLight)
                        }
                    }
                    .padding(.horizontal, 60)
                }
                SearchField(text: $password,
                            fieldSize: 25,
                            isPassword: isHidePassword,
                            isEmail: false)
                .onChange(of: password, perform: bindPassword)
                    .padding(25)
            }
            Button {
                signIn(email, password)
            } label: {
                VStack {
                    Text("Go to Music")
                        .font(Font.custom("Chillax-Semibold", size: 25))
                        .foregroundColor(Color.greenLight)
                }
                .frame(width: 305, height: 70)
                .background(Color.purpleMid)
                .cornerRadius(30)
                .shadow(color: .black, radius: 10)
            }
            .disabled(signViewModel.output.isDisabledButton)
            Spacer()
        }
        .onReceive(signViewModel.successSignIn, perform: { success in
            if success {
                startViewModel.input.accountCompleteSubject.send()
                router.popToRoot()
                dismiss()
            }
        })
        .onAppear {
            signViewModel.setRouter(router)
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purpleMid)
    }
}

extension SignInScreenView {
    func bindEmail(_ email: String) {
        signViewModel.input.emailSubject.send(email)
    }
    
    func bindPassword(_ password: String) {
        signViewModel.input.passwordSubject.send(password)
    }
    
    func signIn(_ email: String, _ password: String) {
        signViewModel.input.signInSubject.send((email, password))

    }
}

struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenView()
    }
}
