//
//  ContentTypeRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name : String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping(MovieList) -> Void)
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity
    
}

class ContentTypeRepositoryImpl : BaseRepository, ContentTypeRepository {
    
    
    
    
    static let shared : ContentTypeRepository = ContentTypeRepositoryImpl()
    
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    
    
    private override init() {
        super.init()
        initializedData()

    }
    
    
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
        
        if let entity = contentTypeMap[type.rawValue] {
            return entity
        }
        return save(name: type.rawValue)
    }
    
  
    
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping (MovieList) -> Void) {
        if let itemSet = contentTypeMap[type.rawValue]?.movies as? Set<MovieEntity> {
            var movieList = MovieList()
            movieList.results = Array(itemSet.sorted(by: { (first,second)-> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                return firstDate.compare(secondDate) == .orderedDescending
            } )).map({ movieEntity in
                
                
                MovieEntity.toMovieResult(entity: movieEntity)
                
                
                
            })
           
            completion(movieList)
        } else {
            completion(MovieList())
        }
            
    }
    
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        contentTypeMap[name] = entity
        coreData.saveContext()
        return entity
    }
   
    
 
    
    private func initializedData(){
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            
            if dataSource.isEmpty {
                MovieSerieGroupType.allCases.forEach {
                  let _ =  save(name : $0.rawValue)
                }
                
            } else {
                 
                dataSource.forEach {
                    if let key = $0.name {
                        contentTypeMap[key] = $0
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
