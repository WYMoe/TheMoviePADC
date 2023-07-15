//
//  BelongsToTypeObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/07/2023.
//

import Foundation
import RealmSwift

class BelongsToTypeObject: Object {
    
   @Persisted(primaryKey: true)
    var name: String
    
    @Persisted(originProperty: "belongsToType")
    var movies : LinkingObjects<MovieObject>
   
    
    
}
