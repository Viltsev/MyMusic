//
//  GeneralEndpoint.swift
//  MyMusic
//
//  Created by Данила on 22.08.2023.
//

import Foundation
import Moya

//typealias IdentifableElement = Int

enum GeneralEndpoint {
    case getTrack(track: String)
}

extension GeneralEndpoint: TargetType {
    
    var baseURL: URL {
        URL(string: "https://spotify-scraper.p.rapidapi.com/v1/track/download")!
    }
    
    var path: String {
        switch self {
        case let .getTrack(track):
            return ""
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .getTrack(track):
            let parameters = ["track": track]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        [ "X-RapidAPI-Key" : "61d39dc457msh8150e5cef2838c7p19c60djsn058afdb343d3",
          "X-RapidAPI-Host" : "spotify-scraper.p.rapidapi.com"
        ]
    }
}
