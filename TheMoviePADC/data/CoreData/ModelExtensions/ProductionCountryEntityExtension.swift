//
//  ProductionCountryEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/07/2023.
//

import Foundation
import CoreData

extension ProductionCountryEntity {
    static func toProductionCountry(entity: ProductionCountryEntity) -> ProductionCountry {
        return ProductionCountry(iso3166_1: entity.iso3166_1, name: entity.name)
    }
     
}
