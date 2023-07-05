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
    func saveSimilarContent(id: Int, data: [Result])
    func getSimilarContent(id: Int, completion: @escaping ([Result]) -> Void)
    func saveCasts(id : Int, data: [ActorInfo])
    func getCasts(id: Int, completion: @escaping ([ActorInfo]) -> Void)

}


class MovieRepositoryImpl : BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryImpl()
    
   private override init() {
    
    }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func getDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {
        
    }
    
    func saveDetail(data: MovieDetail) {
        
    }
    
    func saveList(type: MovieSerieGroupType, data: MovieList) {
        data.results?.forEach{ result in
            result.toMovieEntity(context: self.coreData.context, groupType: contentTypeRepo.getBelongsToTypeEntity(type: type))
        }
        self.coreData.saveContext()
        
    }
    
    func saveSimilarContent(id: Int, data: [Result]) {
        
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([Result]) -> Void) {
        
    }
    
    func saveCasts(id: Int, data: [ActorInfo]) {
        
    }
    
    func getCasts(id: Int, completion: @escaping ([ActorInfo]) -> Void) {
        
    }
    
    
}
