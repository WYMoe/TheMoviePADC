//
//  MovieObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/07/2023.
//

import Foundation
import RealmSwift


class MovieObject : Object {
    
    @Persisted(primaryKey: true)
    var id : Int
    
    @Persisted
    var adult : Bool?
    
    @Persisted
    var backdropPath : String?
    
    @Persisted
    var genreIDS: List<String?>
    
    @Persisted
    var originalLanguage : String?
    
    @Persisted
    var originalTitle: String?
    
    @Persisted
    var originalName : String?
    
    @Persisted
    var overview : String?
    
    @Persisted
    var popularity: Double?
    
    @Persisted
    var posterPath : String?
    
    @Persisted
    var releaseDate : String?
    
    @Persisted
    var firstAirDate: String?
    
    @Persisted
    var title : String?
    
    @Persisted
    var video: Bool?
    
    @Persisted
    var voteAverage : Double?
    
    @Persisted
    var voteCount: Int?
    
    @Persisted
    var revenu : Int?
    
    @Persisted
    var runTime : Int?
    
    @Persisted
    var status : String?
    
    @Persisted
    var tagline : String?
    
    @Persisted
    var lastAirDate : String
    
    @Persisted
    var homePage : String
    
    @Persisted
    var imdbID : String?
    
    @Persisted
    var genres: List<GenreObject>

    @Persisted
    var actors: List<ActorObject>

    @Persisted
    var belongsToCollection: BelongToCollectionObject?

    @Persisted
    var belongsToType: List<BelongsToTypeObject>

    @Persisted
    var spokenLanguages : List<SpokenLanguageObject>

    @Persisted
    var productionCompanies : List<ProductionCompanyObject>

    @Persisted
    var productionCountries : List<ProductionCountryObject>
    
    @Persisted
    var similarMovies : List<MovieObject>
    
    func toMovieResult() -> Result {
        
      genreIDS.forEach { id in
            
        }
        return Result(adult: adult,
                      backdropPath: backdropPath,
                      genreIDS: genreIDS.compactMap({ id in
            Int(id ?? "0")
        }),
                      id: id,
                      originalLanguage: originalLanguage,
                      originalTitle: originalTitle,
                      overview: overview,
                      originalName: originalName,
                      popularity: popularity,
                      posterPath: posterPath,
                      releaseDate: releaseDate,
                      firstAirDate: firstAirDate,
                      title: title,
                      video: video,
                      voteAverage: voteAverage,
                      voteCount: Int(voteCount ?? 0))
    }
    
    
    func toMovieDetail() -> MovieDetail {
        
        let companies : [ProductionCompany] = productionCompanies.map { companyObj in
            companyObj.toProductionCompany()
        }
        
        let countries: [ProductionCountry] = productionCountries.map { countryObj in
            countryObj.toProductionCounty()
        }
        
        let languages : [SpokenLanguage] = spokenLanguages.map { languageObj in
            languageObj.toSpokenLanguage()
        }
        
        let genres : [MovieGenre] = genres.map { genreObj in
            genreObj.toMovieGenre()
        }
       
        
        return MovieDetail(adult: adult, backdropPath: backdropPath, belongsToCollection: nil, budget: 0, genres: genres, homepage: homePage, id: id, imdbID: imdbID, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: popularity, posterPath: posterPath, productionCompanies: companies, productionCountries: countries, releaseDate: releaseDate, revenue: revenu, runtime: runTime, spokenLanguages: languages, status: status, tagline: tagline, title: title, video: video, voteAverage: voteAverage, voteCount: voteCount)
    }
}
