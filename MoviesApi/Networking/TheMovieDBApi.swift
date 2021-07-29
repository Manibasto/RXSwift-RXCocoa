//
//  TheMovieDBApi.swift
//  TheMovies
//
//  Created by Mikhail Pchelnikov on 13/11/2018.
//  Copyright © 2018 Michael Pchelnikov. All rights reserved.
//

import Foundation

import RxSwift

final class TheMovieDBApi {

    let manager: APIManager

    init(manager: APIManager) {
        self.manager = manager
    }
 
    func trendingMovies(_ endpoint: TheMovieDBEndpoint) -> Observable<MoviesResponse> {
        return manager.request(for: endpoint)
            .debug()
            .map(MoviesResponse.parse)
    }
    
    
    func popularMovies(_ endpoint: TheMovieDBEndpoint) -> Observable<MoviesResponse> {
        return manager.request(for: endpoint)
            .debug()
            .map(MoviesResponse.parse)
    }       
}
