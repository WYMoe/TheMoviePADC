//
//  MovieDetail.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/06/2023.
//

import Foundation
import CoreData

// MARK: - MovieDetail
struct MovieDetail: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toMovieEntity(context : NSManagedObjectContext) -> MovieEntity{
        
        let entity = MovieEntity(context: context)
        
        
        
        
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
       
        entity.originalLanguage = originalLanguage
        
       
        entity.originalTitle = originalTitle
        
        entity.overview = overview
        
        entity.popularity = popularity ?? 0
        
        entity.posterPath = posterPath
        
        
        entity.title = title
        
        entity.video = video ?? false
     
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
//        var companyEntityList : [ProductionCompanyEntity] = []
//        var genresEntityList : [GenreEntity] = []
//        var countryEntityList : [ProductionCountryEntity] = []
//        var languageEntityList : [SpokenLanguageEntity] = []
//        var belongToEnitytList : [BelongsToCollectionEntity] = []
        
        
        productionCompanies?.forEach({ company in
            
            let companyEntity = ProductionCompanyEntity(context: context)
            companyEntity.id = Int32(company.id!)
            companyEntity.logoPath  = company.logoPath
            companyEntity.name = company.name
            companyEntity.originCountry = company.originCountry
            
           // companyEntityList.append(company.toProductionCompanyEntity(context: context))
            entity.addToProductionCompanies(companyEntity)
        })
        
      
        
        
    
        productionCompanies?.forEach({ company in
            let companyEntity = ProductionCompanyEntity(context: context)
            companyEntity.id = Int32(company.id!)
            companyEntity.logoPath  = company.logoPath
            companyEntity.name = company.name
            companyEntity.originCountry = company.originCountry
            
            entity.addToProductionCompanies(companyEntity)
         
        })
        
        
        genres?.forEach({ movieGenre in
            let gEntity = GenreEntity(context: context)
            
            gEntity.id = String(movieGenre.id)
            gEntity.name = movieGenre.name
            
            entity.addToGenres(gEntity)
        })
        
        productionCountries?.forEach({ productionCountry in
            let countryEntity = ProductionCountryEntity(context: context)
            countryEntity.iso3166_1 = productionCountry.iso3166_1
            countryEntity.name = productionCountry.name
            
            entity.addToProductionCountries(countryEntity)
        })
        
        spokenLanguages?.forEach({ spokenLanguage in
            
            let languageEntity = SpokenLanguageEntity(context: context)
            
            languageEntity.englishName = spokenLanguage.englishName
            languageEntity.iso639_1 = spokenLanguage.iso639_1
            languageEntity.name = spokenLanguage.name
            
            entity.addToSpokenLanguage(languageEntity)
        })
        
        let belongToEntity = BelongsToCollectionEntity(context: context)
        belongToEntity.id = Int32((belongsToCollection?.id) ?? 0)
        belongToEntity.name = belongsToCollection?.name
        belongToEntity.posterPath = belongsToCollection?.posterPath
        belongToEntity.backdropPath = belongsToCollection?.backdropPath
        
        entity.belongsToCollection = belongToEntity
        
        return entity
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    @discardableResult
    func toProductionCompanyEntity(context : NSManagedObjectContext) -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity(context: context)
        
        entity.id = Int32(id!)
        entity.logoPath = logoPath
        entity.name = name
        entity.originCountry = originCountry
        
        
        return entity
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
   
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
