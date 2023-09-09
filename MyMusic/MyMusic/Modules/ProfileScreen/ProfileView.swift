//
//  ProfileView.swift
//  MyMusic
//
//  Created by Данила on 09.09.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var name: String {
        var name = ""
        for user in dataManager.savedEntities {
            if let email = UserDefaults.standard.string(forKey: "email"), user.email == email {
                name = user.name ?? "HUI"
            }
        }
        return name
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(name)
                    .font(Font.custom("Chillax-Regular", size: 20))
                    //.foregroundColor(Color.greenLight)
            }
            .foregroundColor(Color.greenLight)
            HStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .resizable()
                    .frame(width: 20, height: 15)
                Text(UserDefaults.standard.string(forKey: "email") ?? "")
                    .font(Font.custom("Chillax-Regular", size: 20))
                    //.foregroundColor(Color.greenLight)
            }
            .foregroundColor(Color.greenLight)
            HStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Favorite Tracks")
                    .font(Font.custom("Chillax-Regular", size: 20))
                    //.foregroundColor(Color.greenLight)
            }
            .foregroundColor(Color.greenLight)
            Button {
                
            } label: {
                HStack(spacing: 20) {
                    Image(systemName: "arrow.uturn.down")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Sign Out")
                        .font(Font.custom("Chillax-Regular", size: 20))
                }
            }.foregroundColor(Color.greenLight)
            Spacer()
        }
        .padding(25)
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
