//
//  LogInScreenView.swift
//  MyMusic
//
//  Created by Данила on 07.09.2023.
//

import SwiftUI

struct SignUpScreenView: View {
    @StateObject var signUpViewModel = SignUpViewModel()
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isHidePassword = true
    @State private var alert: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Sign Up")
                    .font(Font.custom("Chillax-Semibold", size: 45))
                    .foregroundColor(Color.greenLight)
                    .padding(25)
            }
            VStack(alignment: .leading, spacing: -10) {
                Text("Name")
                    .font(Font.custom("Chillax-Regular", size: 20))
                    .foregroundColor(Color.greenLight)
                    .padding(.horizontal, 60)
                SearchField(text: $name,
                            fieldSize: 25,
                            isPassword: false,
                            isEmail: false)
                .onChange(of: name, perform: bindName)
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
                signUp(email, password, name)
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
            .onReceive(signUpViewModel.$errorSignUp, perform: { error in
                if error {
                    alert.toggle()
                }
            })
            .disabled(signUpViewModel.output.isDisabledButton)
            Spacer()
        }
        .alert(isPresented: $alert) {
            Alert(
                title: Text("Error!"),
                message: Text(signUpViewModel.output.errorDescription),
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

extension SignUpScreenView {
    func bindEmail(_ email: String) {
        signUpViewModel.input.emailSubject.send(email)
    }
    
    func bindPassword(_ password: String) {
        signUpViewModel.input.passwordSubject.send(password)
    }
    
    func bindName(_ name: String) {
        signUpViewModel.input.nameSubject.send(name)
    }
    
    func signUp(_ email: String, _ password: String, _ name: String) {
        signUpViewModel.input.signUpSubject.send((email, password, name))
    }
}

