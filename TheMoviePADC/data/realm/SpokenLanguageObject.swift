//
//  SpokenLanguageObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/07/2023.
//

import Foundation
import RealmSwift

class SpokenLanguageObject : Object {
    
    @Persisted
    var iso639_1 : String?
    
    @Persisted(primaryKey: true)
    var name : String?
    
    
    @Persisted
    var englishName : String?
    
    func toSpokenLanguage() -> SpokenLanguage {
        SpokenLanguage(englishName: englishName, iso639_1: iso639_1, name: name)
    }
}
