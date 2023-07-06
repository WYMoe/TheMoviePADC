//
//  ProductionCompanyEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/07/2023.
//

import Foundation
import CoreData

extension ProductionCompanyEntity {
    static func toProductionCompany(entity:ProductionCompanyEntity) -> ProductionCompany {
        
        return ProductionCompany(id: Int(entity.id), logoPath: entity.logoPath, name: entity.name, originCountry: entity.originCountry)
    }
}
