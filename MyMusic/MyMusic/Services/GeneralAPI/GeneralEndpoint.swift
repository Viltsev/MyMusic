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
        [ "X-RapidAPI-Key" : "0658d578b3mshb179e5335235cfcp1670cdjsnc2d05548d106",
          "X-RapidAPI-Host" : "spotify-scraper.p.rapidapi.com"
        ]
    }
}
