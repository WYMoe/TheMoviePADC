//
//  MovieRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData

protocol MovieRepository {
    
    func getDetail(id : Int, completion: @escaping (MovieDetail?) -> Void)
    func saveDetail (data: MovieDetail)
    func saveList(type:MovieSerieGroupType, data : MovieList)
    func saveSimilarContent(id: Int, data: MovieList)
    func getSimilarContent(id: Int, completion: @escaping (MovieList) -> Void)
    func saveCasts(id : Int, data: CreditList)
    func getCasts(id: Int, completion: @escaping (CreditList) -> Void)
    func savePopularActorList(list:ActorList) ->Void
    func getPopularActorList(page: Int, completion: @escaping (ActorList) -> Void)
}


class MovieRepositoryImpl : BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryImpl()
    
   private override init() {
    
    }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    var pageSize: Int = 20
    func getDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "popularity", ascending: false)]
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            completion(MovieEntity.toMovieDetail(entity: firstItem))
        }else {
            completion(nil)
        }
        
    }
    
    func saveDetail(data: MovieDetail) {
        let _ = data.toMovieEntity(context: coreData.context)
        coreData.saveContext()
    }
    
    func saveList(type: MovieSerieGroupType, data: MovieList) {
        data.results?.forEach{ result in
            result.toMovieEntity(context: self.coreData.context, groupType: contentTypeRepo.getBelongsToTypeEntity(type: type))
        }
        self.coreData.saveContext()
        
    }
    
    func saveSimilarContent(id: Int, data: MovieList) {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "popularity", ascending: false)]
        
        
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {

            data.results?.map({ result in
                result.toMovieEntity(context: coreData.context, groupType: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits))
            }).forEach({ movieEntity in
                firstItem.addToSimilarMovies(movieEntity)
            })
          
        }
        coreData.saveContext()
    }
    
    func getSimilarContent(id: Int, completion: @escaping (MovieList) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "popularity", ascending: false)]
        
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            var movieList = MovieList()
            movieList.results = (firstItem.similarMovies as? Set<MovieEntity>)?.map({ movieEntity in
                MovieEntity.toMovieResult(entity: movieEntity)
            })
            
            completion(movieList)
        }
    }
    
    func saveCasts(id: Int, data: CreditList) {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "popularity", ascending: false)]
        
        
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            
            data.cast?.map({
                $0.convertToActorInfo()
            }).map({
                $0.toActorEntity(context: coreData.context,contentTypeRepo: contentTypeRepo)
            }).forEach({ actorEntity in
                firstItem.addToCasts(actorEntity)
            })
            
          
            coreData.saveContext()
        }
       

    }
    
    func getCasts(id: Int, completion: @escaping (CreditList) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "popularity", ascending: false)]
        
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first,
           let actorEntities = (firstItem.casts as? Set<ActorEntity>){
           
            var creditList = CreditList()
            creditList.cast = actorEntities.map({ actorEntity in
                ActorEntity.toActorInfo(entity: actorEntity)
            })
            completion(creditList)
        }
    }
    
    func savePopularActorList(list: ActorList) {
        list.results?.forEach({ actorInfo in
            actorInfo.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepo)
        })
        
        coreData.saveContext()
    }
    
    
    func getPopularActorList(page: Int, completion: @escaping (ActorList) -> Void) {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "insertedAt", ascending: false),
        NSSortDescriptor(key: "popularity", ascending: false),
        NSSortDescriptor(key: "name", ascending: true)]
        
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let items = try coreData.context.fetch(fetchRequest)
            var actorList = ActorList()
            actorList.results = items.map({ actorEntity in
                ActorEntity.toPopularActorInfo(entity: actorEntity)
            })
            completion(actorList)
            
        } catch {
            
            print("\(#function) \(error.localizedDescription)")
            completion(ActorList())
        }
    }
}
