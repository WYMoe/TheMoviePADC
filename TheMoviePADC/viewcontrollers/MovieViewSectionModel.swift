//
//  MovieViewSectionModel.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 20/08/2023.
//

import Foundation
import RxDataSources

enum SectionItem {
    case upcomingMoviesSection(items : MovieList)
    case popularMoviesSection(items: MovieList)
    case popularSeriesSection(items: MovieList)
    case movieShowTimeSection
    case movieGenreSection(items: [MovieGenre], data : MovieList)
    case showcaseMoviesSection(items: MovieList)
    case bestActorSection(items: ActorList)
}

enum HomeMovieSectionModel : SectionModelType {
    typealias Item = SectionItem
    
    init(original: HomeMovieSectionModel, items: [Item]) {
        switch original {
        case .movieResult(let results):
            self = .movieResult(items: results)
        case .actorResult(let results):
            self = .actorResult(items: results)
        case .genreResult(let results):
            self = .genreResult(items: results)
        }
    }
    
    var items: [SectionItem] {
        switch self {
        case .movieResult(let items):
            return items
        case .actorResult(let items):
            return items
        case .genreResult(let items):
            return items
        }
    }
    
case movieResult(items : [SectionItem])
case actorResult(items : [SectionItem])
case genreResult(items : [SectionItem])
}
