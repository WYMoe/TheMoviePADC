//
//  GenreEntityExtension.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation

extension GenreEntity {
    static func toMovieGenre(entity : GenreEntity) -> MovieGenre {
        MovieGenre(id: Int(entity.id ?? "0") ?? 0, name: entity.name ?? "")
    }
}
