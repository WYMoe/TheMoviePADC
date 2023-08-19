//
//  ContentTypeRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData
import RealmSwift
import RxSwift
import RxRealm
protocol ContentTypeRepository {
    func save(name : String) -> BelongsToTypeEntity
    func saveObj(name : String) -> BelongsToTypeObject
    
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping(MovieList) -> Void)
    
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity
    func getBelongsToTypeObject(type : MovieSerieGroupType) -> BelongsToTypeObject
    func getwithRx(type : MovieSerieGroupType) -> Observable<MovieList>
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
    
    
    //normal
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
    
    //rx
    func getMovieOrSeries(type:MovieSerieGroupType) -> Observable<MovieList> {
        return Observable.create{ (observer) -> Disposable in
            var notificationToken : NotificationToken?

            if let object : BelongsToTypeObject = self.contentTypeMapObj[type.rawValue] {

                var movieObjects : [MovieObject] = [MovieObject]()

                notificationToken = object.movies.observe( { (change) in
                    switch change {
                    case .initial(let objects) :
                        movieObjects = objects.toArray()
                    case .update(let objects, _,_,_):
                        movieObjects = objects.toArray()
                    case .error(let error):
                        observer.onError(error)
                    }
                    var movieList : MovieList = MovieList()
                    let resultItems = movieObjects
                       //.sorted(by: slef.sortMoviesByDate)
                        .map {
                           $0.toMovieResult()
                        }
                    movieList.results = resultItems
                    observer.onNext(movieList)
                })
            } else {
                observer.onError(MDBEror.withMessage("Failed to get \(type.rawValue) from db"))
            }
            return Disposables.create {
                notificationToken?.invalidate()
            }
        }
    }
    
    //rx
    func getwithRx(type : MovieSerieGroupType) -> Observable<MovieList> {
        if let object : BelongsToTypeObject = self.contentTypeMapObj[type.rawValue] {
            return Observable.collection(from: object.movies)
                .flatMap { movies -> Observable<MovieList> in
                    return Observable.create { observer -> Disposable in
                        var movieList : MovieList = MovieList()
                        var items : [Result] = movies.map { obj in
                            obj.toMovieResult()
                        }
                        movieList.results = items
                        observer.onNext(movieList)
                        return Disposables.create()
                    }
                }
        }
        return Observable.empty()
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
        var notificationToken : NotificationToken?
        let results : Results<BelongsToTypeObject> = realmDB.realm.objects(BelongsToTypeObject.self)
        if results.isEmpty {
            MovieSerieGroupType.allCases.forEach { type in
                let _ = save(name: type.rawValue)
            }
        }else {
            results.forEach { belongsToObject in
                
                contentTypeMapObj[belongsToObject.name] = belongsToObject
                
            }
            
            notificationToken = results.observe({ changes in
                switch changes {
                case .initial(let objects):
                    print(objects.count)
                case .update(let objects, let deletions,let insertions , let modifications):
                    print("inserted index : \(insertions.map {"\($0)"}.joined(separator: ","))")
                    print("deleted index : \(deletions.map {"\($0)"}.joined(separator: ","))")
                    print("modified index : \(modifications.map {"\($0)"}.joined(separator: ","))")
                case .error(let error):
                    print(error)
                }
            })
        }
            
    }
}
