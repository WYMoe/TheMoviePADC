//
//  ActorList.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/06/2023.
//

import Foundation
import CoreData


// MARK: - ActorList
struct ActorList: Codable {
    var page: Int?
    var results: [ActorInfo]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ActorInfo: Codable {
    let adult: Bool?
    let gender, id: Int?
    //let knownFor: [KnownFor]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        //case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
    
    @discardableResult
    func toActorEntity(context : NSManagedObjectContext,contentTypeRepo : ContentTypeRepository) -> ActorEntity{
        
        let entity = ActorEntity(context: context)
        
        entity.adult = adult ?? true
        entity.gender = Int32(gender!)
        entity.id = Int32(id!)
        entity.knownForDepartment = knownForDepartment
        entity.name = name
        
        entity.popularity = Double(popularity!)
        entity.profilePath = profilePath
        

        
        
        
     
        
        return entity
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle, overview, posterPath, releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let firstAirDate, name: String?
    let originCountry: [String]?
    let originalName: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name
        case originCountry = "origin_country"
        case originalName = "original_name"
    }
}

