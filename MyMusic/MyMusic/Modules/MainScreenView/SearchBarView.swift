//
//  SearchBarView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var router: NavigationRouter
    @Binding var show: Bool
    
    var body: some View {
        //ZStack {
            HStack {
                Button {
                    show.toggle()
                } label: {
                    Image(systemName: "text.alignleft")
                        .font(.title2)
                        .foregroundColor(Color.greenLight)
                }
                Spacer()
                Text(.myMusic)
                    .font(Font.custom("Chillax-Semibold", size: 40))
                    .foregroundColor(Color.greenLight)
                Spacer()
                Button {
                    router.pushView(Navigation.pushSearchScreen)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(Color.greenLight)
                }
            }
            .padding(25)
            
            
        //}
        
    }
}

//struct SearchBarView_Previews: PreviewProvider {
//    @State var show: Bool = false
//    static var previews: some View {
//        SearchBarView(show: $show)
//    }
//}
