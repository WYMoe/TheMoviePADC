//
//  ActorEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/07/2023.
//

import Foundation
import CoreData

extension ActorEntity {
    static func toActorInfo(entity: ActorEntity) -> CastInfo {
        return CastInfo(adult: entity.adult, gender: Int(entity.gender), id: Int(entity.id), knownForDepartment: entity.knownForDepartment,
                        name: entity.name, popularity: entity.popularity, profilePath: entity.profilePath)
    }
    
    
    static func toPopularActorInfo(entity: ActorEntity) -> ActorInfo {
        return ActorInfo(adult: entity.adult, gender: Int(entity.gender), id: Int(entity.id), knownForDepartment: entity.knownForDepartment,
                        name: entity.name, popularity: entity.popularity, profilePath: entity.profilePath)
    }
}
