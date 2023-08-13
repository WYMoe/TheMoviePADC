//
//  GenreObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/07/2023.
//

import Foundation
import RealmSwift

class GenreObject : Object {
    @Persisted(primaryKey: true)
    var id : Int
    
    @Persisted
    var name : String
    
    func toMovieGenre() -> MovieGenre {
        MovieGenre(id: id, name: name)
    }
    
}
