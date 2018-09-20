//
//  File.swift
//  Popcorn NightTests
//
//  Created by Michael Isaakidis on 20/09/2018.
//  Copyright © 2018 Michael Isaakidis. All rights reserved.
//

@testable import Popcorn_Night

class TestHelper  {
    
    class func generateMovie(title: String, overview: String) -> Movie {
        return Movie(posterPath: "path/to/poster", backdropPath: nil, overview: overview, releaseDate: "2018-01-03", movieId: 0, title: title, popularity: 0, voteAverage: 8.9, originalLanguage: "En", voteCount: 1, budget: 1, homepage: "www.google.com", revenue: 1000, runtime: 180, tagline: "f", genres: [Genre(genreId: 1, name: "Action")], genreIds: nil)
    }
    
    class func generateMovieArray(numberOfItems: Int) -> [Movie] {
        var movies = [Movie]()
        for i in 1...numberOfItems {
            let title = String(i)
            let movie = generateMovie(title: title, overview: title)
            movies.append(movie)
        }
        return movies
    }
}
