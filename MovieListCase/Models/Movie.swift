//
//  Movie.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import Foundation

struct Movie: Codable {
    let results: [MovieResult]
}

struct MovieResult: Codable {
    let id: Int
    let poster_path: String
    let original_title: String
    let vote_average: Double
    let release_date: String
}
