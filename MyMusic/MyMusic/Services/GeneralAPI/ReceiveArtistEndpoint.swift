//
//  ReceiveArtistEndpoint.swift
//  MyMusic
//
//  Created by Данила on 05.09.2023.
//

import Foundation
import Moya

enum ReceiveArtistEndpoint {
    case receiveArtist(id: String)
}

extension ReceiveArtistEndpoint: TargetType {
    
    var baseURL: URL {
        URL(string: "https://spotify-scraper.p.rapidapi.com/v1/artist/overview")!
    }
    
    var path: String {
        switch self {
        case let .receiveArtist(id):
            return ""
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .receiveArtist(id):
            let parameters = ["artistId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        [ "X-RapidAPI-Key" : "bfe6aef869mshaa163dc68f5fa04p1376bcjsnf79426539437",
          "X-RapidAPI-Host" : "spotify-scraper.p.rapidapi.com"
        ]
    }
}