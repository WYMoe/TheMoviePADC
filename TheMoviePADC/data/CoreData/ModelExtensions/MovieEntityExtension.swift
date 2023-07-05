//
//  MovieEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 03/07/2023.
//

import Foundation
import CoreData

extension MovieEntity {
    static func toMovieResult(entity: MovieEntity)->Result{
        return Result(adult: entity.adult, backdropPath: entity.backdropPath, genreIDS: entity.generalDs?.components(separatedBy: ",").compactMap({ Int($0.trimmingCharacters(in: .whitespaces))
        }), id: Int(entity.id), originalLanguage: entity.originalLanguage, originalTitle: entity.originalTitle, overview: entity.overview, originalName: entity.originalName, popularity: entity.popularity, posterPath: entity.posterPath, releaseDate: entity.releaseDate, firstAirDate: entity.firstAirDate, title: entity.title, video: entity.video, voteAverage: entity.voteAverage, voteCount: Int(entity.voteCount))
    }
}
