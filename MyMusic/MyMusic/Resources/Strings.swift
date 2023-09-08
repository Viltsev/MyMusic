//
//  Strings.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import Foundation

//"myMusic" = "MyMusic";
//"myRecommendations" = "My recommendations";
//"favoriteTracks" = "Favorite Tracks";
//"likeTracks" = "I like these tracks";
//"recentlyPlayed" = "Recently Played";
//"profileMenu" = "text.alignleft";
//"searchTrack" = "magnifyingglass";
//"forwardButton" = "chevron.forward";
//"closeButton" = "xmark";
//"repeatButton" = "repeat";
//"prevTrack" = "backward.fill";
//"stopTrack" = "stop.fill";
//"playTrack" = "play.fill";
//"nextTrack" = "forward.fill";
//"likeButton" = "heart";
//"lyricsButton" = "text.aligncenter";
//"backwardButton" = "chevron.backward";
//"likeFillButton" = "heart.fill";
//"bakeryFont" = "Bakery Holland;


enum Strings: String {
    case myMusic
    case myRecommendations
    case favoriteTracks
    case likeTracks
    case recentlyPlayed
}

enum Language: String {
    case russian = "ru"
    case english_us = "en"
}

extension String {

    func localized(_ language: Language) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }

    func localized(_ language: Language, args arguments: CVarArg...) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return String(format: localized(bundle: bundle), arguments: arguments)
    }

    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
