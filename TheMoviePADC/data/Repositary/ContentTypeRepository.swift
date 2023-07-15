//
//  ContentTypeRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData
import RealmSwift
protocol ContentTypeRepository {
    func save(name : String) -> BelongsToTypeEntity
    func saveObj(name : String) -> BelongsToTypeObject
    
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping(MovieList) -> Void)
    
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity
    func getBelongsToTypeObject(type : MovieSerieGroupType) -> BelongsToTypeObject
    
}

class ContentTypeRepositoryImpl : BaseRepository, ContentTypeRepository {
    
    
    
    static let shared : ContentTypeRepository = ContentTypeRepositoryImpl()
    
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    private var contentTypeMapObj = [String: BelongsToTypeObject]()
    
    private override init() {
        super.init()
        initializedData()

    }
    
    
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
        //core data
        if let entity = contentTypeMap[type.rawValue] {
            return entity
        }
        return save(name: type.rawValue)
    }
    
    func getBelongsToTypeObject(type: MovieSerieGroupType) -> BelongsToTypeObject {
        if let object = contentTypeMapObj[type.rawValue]{
            return object
        }
        return saveObj(name: type.rawValue)
    }
    
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping (MovieList) -> Void) {
        //core data
//        if let itemSet = contentTypeMap[type.rawValue]?.movies as? Set<MovieEntity> {
//            var movieList = MovieList()
//            movieList.results = Array(itemSet.sorted(by: { (first,second)-> Bool in
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
//
//                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
//                return firstDate.compare(secondDate) == .orderedDescending
//            } )).map({ movieEntity in
//
//
//                MovieEntity.toMovieResult(entity: movieEntity)
//
//
//
//            })
//
//            completion(movieList)
//        } else {
//            completion(MovieList())
//        }
    
                if let itemSet = contentTypeMapObj[type.rawValue]?.movies{
                    var movieList = MovieList()
                    movieList.results = Array(itemSet.sorted(by: { (first, second)-> Bool in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                        
                        let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                        return firstDate.compare(secondDate) == .orderedDescending
                    })).map({ movieObj in
                        movieObj.toMovieResult()
                        
                    })
                   
                    completion(movieList)
                } else {
                    completion(MovieList())
                    
                }
            
    }
    
    func save(name: String) -> BelongsToTypeEntity {
        //core data
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        contentTypeMap[name] = entity
        coreData.saveContext()
        
        
        return entity
    }
   
    
    func saveObj(name: String) -> BelongsToTypeObject {
        let object = BelongsToTypeObject()
        
        object.name = name
        
        contentTypeMapObj[name] = object
        try! realmDB.realm.write({
            realmDB.realm.add(object, update: .modified)
        })
        return object
    }
    
  
    
    
    
    
    private func initializedData(){
        //core data
//        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
//
//        do {
//            let dataSource = try self.coreData.context.fetch(fetchRequest)
//
//            if dataSource.isEmpty {
//                MovieSerieGroupType.allCases.forEach {
//                    let _ =  save(name: $0.rawValue)
//                }
//
//            } else {
//
//                dataSource.forEach {
//                    if let key = $0.name {
//                        contentTypeMap[key] = $0
//                    }
//                }
//            }
//        } catch {
//            print(error)
//        }
        
        let results : Results<BelongsToTypeObject> = realmDB.realm.objects(BelongsToTypeObject.self)
        if results.isEmpty {
            MovieSerieGroupType.allCases.forEach { type in
                let _ = save(name: type.rawValue)
            }
        }else {
            results.forEach { belongsToObject in
                
                contentTypeMapObj[belongsToObject.name] = belongsToObject
                
            }
        }
            
    }
}
