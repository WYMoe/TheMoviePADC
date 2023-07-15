//
//  ProductionCompanyObject.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/07/2023.
//

import Foundation
import RealmSwift

class ProductionCompanyObject : Object {
    
    @Persisted(primaryKey: true)
    var id : Int?
    
    @Persisted
    var logoPath : String?
    
    @Persisted
    var name : String?
    
    @Persisted
    var originCountry : String?
    
    func toProductionCompany() -> ProductionCompany {
        return ProductionCompany(id: id, logoPath: logoPath, name: name, originCountry: originCountry)
    }
}
