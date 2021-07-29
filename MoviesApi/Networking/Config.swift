//
//  Config.swift
//  TheMovies
//
//  Created by Mikhail Pchelnikov on 09/06/2018.
//  Copyright © 2018 Michael Pchelnikov. All rights reserved.
//

import Foundation

/// Constants and static data.
struct Config {

    static let apiKey = "7e718bbe884ff492360be457092aa3fb"
    
    static let maxQueriesHistoryCount = 10

    struct URL {
        static let base = "http://api.themoviedb.org/3/"
        static let basePoster = "http://image.tmdb.org/t/p"
    }
    
    struct Keys {
        static let queriesHistory = "_queriesHistory"
    }
    
    struct CellIdentifier {
        struct MovieTable {
            static let popularMovies = "PopularCell"
            static let trendingMovies = "TrendingCell"
            static let trendingCollection = "TrendingCollectionCell"
            static let movieCell = "MovieItemCell"
            static let historyCell = "HistoryItemCell"
        }
    }
    
    struct header {
        struct headerText {
            static let popularMovies = "Popular Movies"
            static let trendingMovies = "Trending Movies"
        }
    }
}
