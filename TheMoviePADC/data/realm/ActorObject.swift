//
//  ActorObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/07/2023.
//

import Foundation
import RealmSwift


class ActorObject : Object {
    
    @Persisted
    var adult: Bool?
    
    @Persisted
    var gender: Int?
        
    @Persisted(primaryKey: true)
    var id: Int?
    
//    @Persisted
//    var knownFor: [KnownFor]?
    
    @Persisted
    var knownForDepartment: String?
    
    @Persisted
    var name: String?

    @Persisted
    var popularity: Double?
    
    @Persisted
    var profilePath: String?
    
    func toActorInfo()->ActorInfo {
        
        return ActorInfo(adult: adult, gender: gender, id: id, knownForDepartment: knownForDepartment, name: name, popularity: popularity, profilePath: profilePath)
    }
    
    
}
