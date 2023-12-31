//
//  RecommendationsCircleView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI

struct RecommendationsCircleView: View {
    @State private var shadowRadius = 50
    
    var body: some View {
        HStack {
            Button {
                // action
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color.purpleDark)
                        .frame(width: 250, height: 250)
                        .shadow(color: Color.purpleLight, radius: CGFloat(shadowRadius))
                        .onTapGesture {
                            withAnimation(.linear(duration: 3).repeatForever()) {
                                shadowRadius = 10
                            }
                        }
                    Text(.myRecommendations)
                        .font(Font.custom("Chillax-Regular", size: 20))
                        .foregroundColor(Color.white)
                }
            }
        }.padding(.vertical, 50)
    }
}

struct RecommendationsCircleView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsCircleView()
    }
}
