//
//  CreditList.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 10/06/2023.
//

import Foundation


// MARK: - CreditList
struct CreditList: Codable {
    let id: Int?
    let cast, crew: [CastInfo]?
}

// MARK: - Cast
struct CastInfo: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: String?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func convertToActorInfo ()->ActorInfo{
        return ActorInfo(adult: self.adult, gender: self.gender, id: self.id, knownFor: nil,knownForDepartment: self.knownForDepartment, name: self.name, popularity: self.popularity, profilePath: self.profilePath)
    }
}

