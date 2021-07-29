//
//  Endpoint.swift
//  TheMovies
//
//  Created by Mikhail Pchelnikov on 13/11/2018.
//  Copyright © 2018 Michael Pchelnikov. All rights reserved.
//

import Foundation

protocol Endpoint {
    var path: String { get }
}

typealias SearchMovieParams = (query: String, page: Int)

enum TheMovieDBEndpoint {
    case trendingMovies
    case popularMovies(page: Int)
}

extension TheMovieDBEndpoint: Endpoint {
    var path: String {
        switch self {
        case .trendingMovies:
            return "\(Config.URL.base)trending/all/day?api_key=\(Config.apiKey)"
        case let .popularMovies(page: page):
            return "\(Config.URL.base)movie/popular/?api_key=\(Config.apiKey)&language=en-US&page=\(page)"
        }
    }
}
