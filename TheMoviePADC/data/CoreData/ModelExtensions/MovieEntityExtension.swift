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
    static func toMovieDetail(entity: MovieEntity)->MovieDetail{
        let belongToCollection = BelongsToCollectionEntity.toBelongsToCollection(entity: entity.belongsToCollection ?? BelongsToCollectionEntity())
        let genres = entity.genres?.map({ gEntity in
            GenreEntity.toMovieGenre(entity: gEntity as! GenreEntity)
        })
        let companies = entity.productionCompanies?.map({ companyEntity in
            ProductionCompanyEntity.toProductionCompany(entity: companyEntity as! ProductionCompanyEntity)
        })
        let countries = entity.productionCountries?.map({ countryEntity in
            ProductionCountryEntity.toProductionCountry(entity: countryEntity as! ProductionCountryEntity)
        })
        
        let languages = entity.spokenLanguage?.map({ languageEntity in
            SpokenLanguageEntity.toSpokenLanguage(entity: languageEntity as! SpokenLanguageEntity)
        })
        return MovieDetail(adult: entity.adult, backdropPath: entity.backdropPath, belongsToCollection:belongToCollection, budget: Int(entity.budget), genres: genres, homepage: entity.homePage, id:Int(entity.id), imdbID: entity.imdbID, originalLanguage: entity.originalLanguage, originalTitle: entity.originalTitle, overview: entity.overview, popularity: entity.popularity, posterPath: entity.posterPath, productionCompanies: companies, productionCountries: countries, releaseDate: entity.releaseDate, revenue: Int(entity.revenu), runtime: Int(entity.runTime), spokenLanguages: languages, status: entity.status, tagline: entity.tagline, title: entity.title, video:entity.video , voteAverage: Double(entity.voteCount), voteCount: Int(entity.voteCount))
    }
  
}
