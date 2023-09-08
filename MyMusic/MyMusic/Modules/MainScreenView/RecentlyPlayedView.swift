//
//  RecentlyPlayedView.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import SwiftUI

struct RecentlyPlayedView: View {
    var body: some View {
        HStack {
            Text(.recentlyPlayed)
                .font(Font.custom("Bakery Holland", size: 30))
                .foregroundColor(Color.greenLight)
                .padding(.horizontal, 25)
            Spacer()
        }
    }
}

struct RecentlyPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayedView()
    }
}
