//
//  ReceiveAlbumEndpoint.swift
//  MyMusic
//
//  Created by Данила on 16.09.2023.
//

import Foundation
import Moya

enum ReceiveAlbumEndpoint {
    case receiveAlbum(id: String)
}

extension ReceiveAlbumEndpoint: TargetType {
    
    var baseURL: URL {
        URL(string: "https://spotify-scraper.p.rapidapi.com/v1/album/tracks")!
    }
    
    var path: String {
        switch self {
        case let .receiveAlbum(id):
            return ""
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .receiveAlbum(id):
            let parameters = ["albumId": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        [ "X-RapidAPI-Key" : "cd02c58415mshb53743187d9ff8ap1c314fjsn07806753884e",
          "X-RapidAPI-Host" : "spotify-scraper.p.rapidapi.com"
        ]
    }
}
