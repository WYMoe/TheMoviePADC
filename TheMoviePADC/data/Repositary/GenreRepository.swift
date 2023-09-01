//
//  GenreRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData
import RealmSwift
import RxSwift

protocol GenreRepository {
    func getGenreListWithRx() -> Observable<MovieGenreList> 
    func get(completion: @escaping (MovieGenreList) -> Void)
    func save(data : MovieGenreList)
}


class GenreRepositoryImpl : BaseRepository,GenreRepository {
    
    
    
    static let shared : GenreRepository = GenreRepositoryImpl()
    
    private override init() {
        
    }
    
    
   
    
    
    
    //save genre
    func save(data: MovieGenreList) {

        //core data
//        data.genres?.forEach({ movieGenre in
//            let entity = GenreEntity(context: coreData.context)
//
//            entity.id = String(movieGenre.id)
//            entity.name = movieGenre.name
//
//        })
//        coreData.saveContext()
        
        //realm
        data.genres?.forEach({ movieGenre in
            let object = GenreObject()
            
            object.id = movieGenre.id
            object.name = movieGenre.name
            
            try! realmDB.realm.write({
                realmDB.realm.add(object, update: .modified)
            })
        })
    }
    
    //get genre
    func get(completion: @escaping (MovieGenreList) -> Void) {
        
        //core data
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
        
        //realm
        let results: Results<GenreObject> = realmDB.realm.objects(GenreObject.self)
        let items : [MovieGenre] =  results.map { genreObj in
            genreObj.toMovieGenre()
        }
        var mobieGenreList : MovieGenreList = MovieGenreList()
        mobieGenreList.genres = items
        completion(mobieGenreList)
        
    }
    
    //get genre with RxRealm
    func getGenreListWithRx() -> Observable<MovieGenreList> {
        let results: Results<GenreObject> = realmDB.realm.objects(GenreObject.self)
        
        
        return Observable.collection(from: results)
              .map { genreObjs in
                  let items : [MovieGenre] =  genreObjs.map { genreObj in
                      genreObj.toMovieGenre()
                  }
                  var movieGenreList : MovieGenreList = MovieGenreList()
                  movieGenreList.genres = items
                  return movieGenreList
              }
            
            
            
    }
    
}
