//
//  TabBarViewModel.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import Foundation

enum TabBarItem: Int {
    case mainScreen
    case favoriteTracks
}

final class TabBarViewModel: ObservableObject {
    
    var selectedItem: TabBarItem = .mainScreen {
        willSet {
            if newValue == selectedItem {
                switch newValue {
                case .mainScreen:
                    mainScreen.popToRoot()
                case .favoriteTracks:
                    favoriteTracks.popToRoot()
                }
            }
        }
    }
    
    var mainScreen = NavigationRouter()
    var favoriteTracks = NavigationRouter()
}
