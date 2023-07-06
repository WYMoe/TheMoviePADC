//
//  BelongToEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/07/2023.
//

import Foundation
import CoreData

extension BelongsToCollectionEntity {
    static func toBelongsToCollection(entity : BelongsToCollectionEntity)-> BelongsToCollection{
        return BelongsToCollection(id: Int(entity.id), name: entity.name, posterPath: entity.posterPath, backdropPath: entity.backdropPath)
    }
}
