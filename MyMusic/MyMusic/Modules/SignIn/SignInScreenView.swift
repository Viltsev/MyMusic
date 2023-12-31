//
//  SignInScreenView.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import SwiftUI

struct SignInScreenView: View {
    @StateObject var signInViewModel = SignInViewModel()

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isHidePassword = true
    @State private var alert: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Sign In")
                    .font(Font.custom("Chillax-Semibold", size: 45))
                    .foregroundColor(Color.greenLight)
                    .padding(25)
            }
            VStack(alignment: .leading, spacing: -10) {
                Text("Email")
                    .font(Font.custom("Chillax-Regular", size: 20))
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
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.greenLight)
                        .padding(.horizontal, 60)
                    Spacer()
                    Button {
                        isHidePassword.toggle()
                    } label: {
                        if isHidePassword {
                            Text("show")
                                .font(Font.custom("Chillax-Regular", size: 15))
                                .foregroundColor(Color.greenLight)
                        } else {
                            Text("hide")
                                .font(Font.custom("Chillax-Regular", size: 15))
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
                        .foregroundColor(Color.purpleDark)
                }
                .frame(width: 305, height: 70)
                .background(Color.greenLight)
                .cornerRadius(30)
            }
            .onReceive(signInViewModel.$errorSignIn, perform: { error in
                if error {
                    alert.toggle()
                }
            })
            .disabled(signInViewModel.output.isDisabledButton)
            Spacer()
        }
        .alert(isPresented: $alert) {
            Alert(
                title: Text("Error!"),
                message: Text(signInViewModel.output.errorDescription),
                primaryButton: .default(Text("OK")) {
                    alert = false
                },
                secondaryButton: .cancel() {
                    alert = false
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purpleMid)
    }
}

extension SignInScreenView {
    func bindEmail(_ email: String) {
        signInViewModel.input.emailSubject.send(email)
    }
    
    func bindPassword(_ password: String) {
        signInViewModel.input.passwordSubject.send(password)
    }
    
    func signIn(_ email: String, _ password: String) {
        signInViewModel.input.signInSubject.send((email, password))
    }
}


        
    
