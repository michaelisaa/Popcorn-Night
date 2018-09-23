//
//  Movie.swift
//  Popcorn Night
//
//  Created by Michael Isaakidis on 17/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let genreId: Int
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case genreId = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        genreId = try container.decode(Int.self, forKey: .genreId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(genreId, forKey: .genreId)
    }
}

struct Movie: Codable {
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
    let homepage: String?
    let revenue: Int?
    let runtime: Int?
    var genres: [Genre]?
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
        case homepage = "homepage"
        case revenue = "revenue"
        case runtime = "runtime"
        case genres = "genres"
        case genreIds = "genre_ids"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        backdropPath = try? container.decode(String.self, forKey: .backdropPath)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        movieId = try container.decode(Int.self, forKey: .movieId)
        title = try container.decode(String.self, forKey: .title)
        popularity = try container.decode(Float.self, forKey: .popularity)
        voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        revenue = try? container.decode(Int.self, forKey: .revenue)
        runtime = try? container.decode(Int.self, forKey: .runtime)
        originalLanguage = try? container.decode(String.self, forKey: .originalLanguage)
        homepage = try? container.decode(String.self, forKey: .homepage)
        genreIds = try? container.decode([Int].self, forKey: .genreIds)
        genres = try? container.decode([Genre].self, forKey: .genres)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(overview, forKey: .overview)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(movieId, forKey: .movieId)
        try container.encode(title, forKey: .title)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)
        try container.encode(revenue, forKey: .revenue)
        try container.encode(runtime, forKey: .runtime)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(homepage, forKey: .homepage)
        try container.encode(genreIds, forKey: .genreIds)
        try container.encode(genres, forKey: .genres)
    }
    
    func genresString() -> String? {
        if let genres = genres {
            return genres.map { (genre) -> String in
                genre.name!
                }.joined(separator: " | ")
        }
        return nil
    }
    
    func releaseYear() -> String {
        return String(releaseDate.split(separator: "-").first!)
    }
}
