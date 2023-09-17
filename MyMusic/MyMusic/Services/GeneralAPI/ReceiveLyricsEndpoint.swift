//
//  ReceiveLyricsEndpoint.swift
//  MyMusic
//
//  Created by Данила on 18.09.2023.
//

import Foundation
import Moya

enum ReceiveLyricsEndpoint {
    case receiveLyrics(id: String)
}

extension ReceiveLyricsEndpoint: TargetType {
    
    var baseURL: URL {
        URL(string: "https://spotify23.p.rapidapi.com/track_lyrics/")!
    }
    
    var path: String {
        switch self {
        case let .receiveLyrics(id):
            return ""
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .receiveLyrics(id):
            let parameters = ["id": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        [ "X-RapidAPI-Key" : "cd02c58415mshb53743187d9ff8ap1c314fjsn07806753884e",
          "X-RapidAPI-Host" : "spotify23.p.rapidapi.com"
        ]
    }
}
