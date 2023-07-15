//
//  GenreRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData
import RealmSwift

protocol GenreRepository {
    
    func get(completion: @escaping (MovieGenreList) -> Void)
    func save(data : MovieGenreList)
}


class GenreRepositoryImpl : BaseRepository,GenreRepository {
    
    
    
    static let shared : GenreRepository = GenreRepositoryImpl()
    
    private override init() {
        
    }
    
    
    func get(completion: @escaping (MovieGenreList) -> Void) {
//        let fetchRequest : NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "name", ascending: true)]
//
//        do {
//            let results : [GenreEntity] = try coreData.context.fetch(fetchRequest)
//            let items = results.map { entity in
//                GenreEntity.toMovieGenre(entity: entity)
//            }
//
//            var movieGenreList : MovieGenreList = MovieGenreList()
//            movieGenreList.genres = items
//
//            completion(movieGenreList)
//
//        } catch {
//           completion(MovieGenreList())
//            print("\(#function) \(error.localizedDescription)")
//        }
        
        let results: Results<GenreObject> = realmDB.realm.objects(GenreObject.self)
        let items : [MovieGenre] =  results.map { genreObj in
            genreObj.toMovieGenre()
        }
        var mobieGenreList : MovieGenreList = MovieGenreList()
        mobieGenreList.genres = items
        completion(mobieGenreList)
        
    }
    
    
    func save(data: MovieGenreList) {

        
//        data.genres?.forEach({ movieGenre in
//            let entity = GenreEntity(context: coreData.context)
//
//            entity.id = String(movieGenre.id)
//            entity.name = movieGenre.name
//
//        })
//        coreData.saveContext()
        
        data.genres?.forEach({ movieGenre in
            let object = GenreObject()
            
            object.id = movieGenre.id
            object.name = movieGenre.name
            
            try! realmDB.realm.write({
                realmDB.realm.add(object, update: .modified)
            })
        })
    }
    
    
}
