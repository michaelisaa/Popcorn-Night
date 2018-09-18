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
    let overview: String
    let releaseDate: String
    let id: Int
    let title: String
    let popularity: Float
    let voteAverage: Float
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case overview = "overview"
        case releaseDate = "release_date"
        case id = "id"
        case title = "title"
        case popularity = "popularity"
        case voteAverage = "vote_average"
    }
}
