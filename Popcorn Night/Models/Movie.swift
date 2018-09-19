//
//  Movie.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String
    let id: Int
    let title: String
    let popularity: Float
    let voteAverage: Float
    let originalLanguage: String?
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case overview = "overview"
        case releaseDate = "release_date"
        case id = "id"
        case title = "title"
        case popularity = "popularity"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
    }
}
