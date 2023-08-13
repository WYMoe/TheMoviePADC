//
//  ProductionCountryObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/07/2023.
//

import Foundation
import RealmSwift


class ProductionCountryObject : Object {
    
    @Persisted
    var iso3166_1 : String?
    
    @Persisted
    var name: String?
    
    func toProductionCounty()->ProductionCountry{
        return ProductionCountry(iso3166_1: iso3166_1, name: name)
    }

}
