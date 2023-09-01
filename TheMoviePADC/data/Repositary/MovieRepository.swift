//
//  MovieRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData
import RealmSwift
import RxSwift
import RxCocoa

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
    func getPopularActorListwithRx() -> Observable<ActorList>
}


class MovieRepositoryImpl : BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryImpl()
    
   private override init() {
    
    }
    
    
 
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    private var contentTypeMapObj = [String: BelongsToTypeObject]()
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    var pageSize: Int = 100
    
    //save movies
    func saveList(type: MovieSerieGroupType, data: MovieList) {
        
        ///Core Data
//        data.results?.forEach{ result in
//            result.toMovieEntity(context: self.coreData.context, groupType: contentTypeRepo.getBelongsToTypeEntity(type: type))
//        }
//        self.coreData.saveContext()
        
        
        /// Realm
        data.results?.forEach({ result in
            let object = MovieObject()

            object.adult = result.adult
            object.backdropPath = result.backdropPath


            result.genreIDS?.forEach({ genreID in
                object.genreIDS.append(String(genreID))
            })

            object.id = result.id ?? 0
            object.originalLanguage = result.originalLanguage
            object.originalTitle = result.originalTitle
            object.overview = result.overview
            object.originalName = result.originalName
            object.popularity = result.popularity
            object.posterPath = result.posterPath
            object.releaseDate = result.releaseDate
            object.firstAirDate = result.firstAirDate
            object.title = result.title
            object.video = result.video
            object.voteAverage = result.voteAverage
            object.voteCount = result.voteCount
            
            object.belongsToType.append(contentTypeRepo.getBelongsToTypeObject(type: type))
           
            
                try! self.realmDB.realm.write{
                    self.realmDB.realm.add(object,update: .modified)
                }
           
        })
       
        
    }
    
    //save detail
    func saveDetail(data: MovieDetail) {
        
        //core data
//        let _ = data.toMovieEntity(context: coreData.context)
//        coreData.saveContext()
        
        
        //realm
        let object = MovieObject()
        
        object.id = data.id ?? 0
        object.adult = data.adult ?? false
        object.backdropPath =  data.backdropPath
        object.originalLanguage = data.originalLanguage
        object.originalTitle = data.originalTitle
        object.overview = data.overview
        object.popularity = data.popularity ?? 0
        object.posterPath = data.posterPath
        object.title = data.title
        object.video = data.video ?? false
        object.voteAverage = data.voteAverage ?? 0
        object.voteCount = data.voteCount
        object.releaseDate = data.releaseDate
        object.runTime = data.runtime
        object.revenu = data.revenue
        object.status = data.status
        object.tagline = data.tagline
        
        
        
     
        data.genres?.forEach({ genre in
            let genreObj = GenreObject()
            
            genreObj.name = genre.name
            genreObj.id = genre.id
            
            object.genres.append(genreObj)
        })
        
        data.productionCompanies?.forEach({ productionCompany in
            let companyObj = ProductionCompanyObject()
            
            companyObj.id = productionCompany.id
            companyObj.logoPath = productionCompany.logoPath
            companyObj.name = productionCompany.name
            companyObj.originCountry = productionCompany.originCountry
            object.productionCompanies.append(companyObj)
        })
        
        data.productionCountries?.forEach({ country in
            let countryObj = ProductionCountryObject()
            
            countryObj.iso3166_1 = country.iso3166_1
            countryObj.name = country.name
            object.productionCountries.append(countryObj)
        })
        
        data.spokenLanguages?.forEach({ language in
            let languageObj = SpokenLanguageObject()
            languageObj.englishName = language.englishName
            languageObj.iso639_1 = language.iso639_1
            languageObj.name = language.name
            object.spokenLanguages.append(languageObj)
        })
        
        try! realmDB.realm.write({
            realmDB.realm.add(object, update: .modified)
        })
        
        
        
      
    }
    
    //get detail
    func getDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {
        
        //core data
//        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
//        fetchRequest.sortDescriptors = [
//        NSSortDescriptor(key: "popularity", ascending: false)]
//
//        if let items = try? coreData.context.fetch(fetchRequest),
//           let firstItem = items.first {
//            completion(MovieEntity.toMovieDetail(entity: firstItem))
//        }else {
//            completion(nil)
//        }
        
        
        //realm
        let result:Results<MovieObject> = realmDB.realm.objects(MovieObject.self)
            .filter("%K = %@", "id",id)
            .sorted(byKeyPath: "popularity",ascending: false)
        
        if let item = result.first {
            completion(item.toMovieDetail())
        }
        

        
        
        
    }
    
    
    
  
    //save similar content
    func saveSimilarContent(id: Int, data: MovieList) {
        
        //core data
//        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
//        fetchRequest.sortDescriptors = [
//        NSSortDescriptor(key: "popularity", ascending: false)]
//
//
//
//        if let items = try? coreData.context.fetch(fetchRequest),
//           let firstItem = items.first {
//
//            data.results?.map({ result in
//                result.toMovieEntity(context: coreData.context, groupType: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits))
//            }).forEach({ movieEntity in
//                firstItem.addToSimilarMovies(movieEntity)
//            })
//
//        }
//        coreData.saveContext()
        
        //realm
        let movieObj = realmDB.realm.object(ofType: MovieObject.self, forPrimaryKey: id)
      
        try! realmDB.realm.write({
            
            
            let movieObjList : [MovieObject] = data.results?.map({ result in

                let obj = MovieObject()
                
                obj.adult = result.adult
                obj.backdropPath = result.backdropPath
                obj.id = result.id ?? 0
                obj.originalLanguage = result.originalLanguage
                obj.originalTitle = result.originalTitle
                obj.overview = result.overview
                obj.originalName = result.originalName
                obj.popularity = result.popularity
                obj.posterPath = result.posterPath
                obj.releaseDate = result.releaseDate
                obj.firstAirDate = result.firstAirDate
                obj.title = result.title
                obj.video = result.video
                obj.voteAverage = result.voteAverage
                obj.voteCount = result.voteCount

                return obj
            }) ?? [MovieObject]()
            //print(movieObjList)
            
          
            movieObjList.forEach({ movie in
                movieObj?.similarMovies.append(movie)
            })
            




        })

        
        
    }
    
    //get similar content
    func getSimilarContent(id: Int, completion: @escaping (MovieList) -> Void) {
        //core data
//        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id","\(id)")
//        fetchRequest.sortDescriptors = [
//        NSSortDescriptor(key: "popularity", ascending: false)]
//
//
//        if let items = try? coreData.context.fetch(fetchRequest),
//           let firstItem = items.first {
//            var movieList = MovieList()
//            movieList.results = (firstItem.similarMovies as? Set<MovieEntity>)?.map({ movieEntity in
//                MovieEntity.toMovieResult(entity: movieEntity)
//            })
//
//            completion(movieList)
//        }
        
        
        //realm
        let results:Results<MovieObject> = realmDB.realm.objects(MovieObject.self)
            .filter("%K = %@", "id",id)
            .sorted(byKeyPath: "popularity",ascending: false)
        
        if let firstItem = results.first {
            var movieList = MovieList()
            movieList.results = firstItem.similarMovies.map({ movieObj in
                movieObj.toMovieResult()
            })
            
            completion(movieList)
        }
        
    }
    
    //save cast
    func saveCasts(id: Int, data: CreditList) {
        //core data
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
    
    //get cast
    func getCasts(id: Int, completion: @escaping (CreditList) -> Void) {
        
        //core data
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
    
    //save popular people
    func savePopularActorList(list: ActorList) {
        
        //core data
//        list.results?.forEach({ actorInfo in
//            actorInfo.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepo)
//        })
//
//        coreData.saveContext()
      
        
        //realm
        list.results?.forEach({ actorInfo in
            let object = ActorObject()
            
            
            object.adult =  actorInfo.adult ?? true
            object.gender = actorInfo.gender
            object.id =     actorInfo.id
            object.knownForDepartment = actorInfo.knownForDepartment
            object.name = actorInfo.name
            object.popularity = actorInfo.popularity
            object.profilePath = actorInfo.profilePath
            
            try! realmDB.realm.write({
                realmDB.realm.add(object, update: .modified)
            })
        })
    }
    
    //get popular people
    func getPopularActorList(page: Int, completion: @escaping (ActorList) -> Void) {
        
        //core data
//        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
//
//        fetchRequest.sortDescriptors = [
//        NSSortDescriptor(key: "insertedAt", ascending: false),
//        NSSortDescriptor(key: "popularity", ascending: false),
//        NSSortDescriptor(key: "name", ascending: true)]
//
//
//        fetchRequest.fetchLimit = pageSize
//        fetchRequest.fetchOffset = (pageSize * page) - pageSize
//
//        do {
//            let items = try coreData.context.fetch(fetchRequest)
//            var actorList = ActorList()
//            actorList.results = items.map({ actorEntity in
//                ActorEntity.toPopularActorInfo(entity: actorEntity)
//            })
//            completion(actorList)
//
//        } catch {
//
//            print("\(#function) \(error.localizedDescription)")
//            completion(ActorList())
//        }
        
        //realm
        let results : Results<ActorObject> = realmDB.realm.objects(ActorObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
            .sorted(byKeyPath: "name", ascending:  true)
        
        var actorList = ActorList()
        let items : [ActorInfo] = results.map({ actorObj in
            actorObj.toActorInfo()
        })
        
        actorList.results = items
        completion(actorList)
        
        
        

    }
    
    //get poular people with RxRealm
    func getPopularActorListwithRx() -> Observable<ActorList> {
        let results : Results<ActorObject> = realmDB.realm.objects(ActorObject.self)
            
            .sorted(byKeyPath: "popularity", ascending: false)
            .sorted(byKeyPath: "name", ascending:  true)
        
        return Observable.collection(from: results)
              .map { actorObjects in
                  var actorList = ActorList()
                  actorList.results = actorObjects.map({ obj in
                      obj.toActorInfo()
                  })
                  return actorList
              }
            
            
            
    }
  
        
}
