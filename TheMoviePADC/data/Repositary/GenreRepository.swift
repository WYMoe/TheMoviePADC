//
//  GenreRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData

protocol GenreRepository {
    
    func get(completion: @escaping (MovieGenreList) -> Void)
    func save(data : MovieGenreList)
}


class GenreRepositoryImpl : BaseRepository,GenreRepository {
    
    
    
    static let shared : GenreRepository = GenreRepositoryImpl()
    
    private override init() {
        
    }
    
    
    func get(completion: @escaping (MovieGenreList) -> Void) {
        let fetchRequest : NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let results : [GenreEntity] = try coreData.context.fetch(fetchRequest)
            let items = results.map { entity in
                GenreEntity.toMovieGenre(entity: entity)
            }
            
            var movieGenreList : MovieGenreList = MovieGenreList()
            movieGenreList.genres = items
            
            completion(movieGenreList)
           
        } catch {
           completion(MovieGenreList())
            print("\(#function) \(error.localizedDescription)")
        }
        
        
    }
    
    
    func save(data: MovieGenreList) {

        
        data.genres?.forEach({ movieGenre in
            let entity = GenreEntity(context: coreData.context)
            
            entity.id = String(movieGenre.id)
            entity.name = movieGenre.name

        })
        coreData.saveContext()
    }
    
    
}
