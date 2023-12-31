//
//  MovieType.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 13/04/2023.
//

import Foundation

enum MovieType : Int {
case MOVIE_SLIDER = 0
case MOVIE_POPULAR = 1
case SERIES_POPULAR = 2
case MOVIE_SHOWTIME = 3
case MOVIE_GENRE = 4
case MOVIE_SHOWCASE = 5
case MOVIE_BEST_ACTOR = 6
}

enum MovieSerieGroupType : String, CaseIterable {
    case upcomingMovies = "Upcoming Movies"
    case popularMovies = "Popular Movies"
    case topRatedMovies = "Top Rated Movies"
    case pupularSeries = "Popular Series"
    case upcomingSeries = "Upcoming Series"
    case actorCredits = "Actor Credits"
}
