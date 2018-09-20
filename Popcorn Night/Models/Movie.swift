//
//  Movie.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    let genreId: Int
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case genreId = "id"
        case name = "name"
    }
}

struct Movie: Decodable {
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String
    let movieId: Int
    let title: String
    let popularity: Float
    let voteAverage: Float
    let originalLanguage: String?
    let voteCount: Int
    let budget: Int?
    let homepage: String?
    let revenue: Int?
    let runtime: Int?
    let tagline: String?
    let genres: [Genre]?
    let genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case overview = "overview"
        case releaseDate = "release_date"
        case movieId = "id"
        case title = "title"
        case popularity = "popularity"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case budget = "budget"
        case homepage = "homepage"
        case revenue = "revenue"
        case runtime = "runtime"
        case tagline = "tagline"
        case genres = "genres"
        case genreIds = "genre_ids"
    }
}
