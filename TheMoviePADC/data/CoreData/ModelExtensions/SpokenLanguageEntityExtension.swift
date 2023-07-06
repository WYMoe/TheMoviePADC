//
//  SpokenLanguageEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/07/2023.
//

import Foundation
import CoreData

extension SpokenLanguageEntity {
    
    static func toSpokenLanguage(entity: SpokenLanguageEntity) -> SpokenLanguage {
        return SpokenLanguage(englishName: entity.englishName, iso639_1: entity.iso639_1, name: entity.name)
    }
}
