//
//  BelongsToCollectionObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/07/2023.
//

import Foundation
import RealmSwift

class BelongToCollectionObject : Object {
    @Persisted(primaryKey:  true)
    var id : Int
    
    @Persisted
    var backdropthPath : String
    
    @Persisted
    var name : String?
    
    @Persisted
    var posterPath : String?
    
    func toBelongsToCollection() -> BelongsToCollection {
      return BelongsToCollection(id: id, name: name, posterPath: posterPath, backdropPath: backdropthPath)
    }
}
