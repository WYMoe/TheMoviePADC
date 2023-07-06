//
//  MovieDetailModel.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 16/06/2023.
//

import Foundation

protocol MovieDetailModel {
    func getMovieTrailersById( id: Int, completion:@escaping(MDBResult<MovieTrailerList>)->Void)
    func getSimilarMovieById ( id: Int, completion:@escaping(MDBResult<MovieList>)->Void)
    func getCreditById ( id: Int, completion:@escaping(MDBResult<CreditList>)->Void)
    func getMovieDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void)
  
    
}

class MovieDetailModelImpl : BaseModel,MovieDetailModel {
        
    
    static let shared = MovieDetailModelImpl()
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    private override init() {
       
   }
    
    func getMovieTrailersById(id: Int, completion: @escaping (MDBResult<MovieTrailerList>) -> Void) {
        networkAgent.getMovieTrailersById(id: id, completion: completion)
    }

    func getSimilarMovieById(id: Int, completion: @escaping (MDBResult<MovieList>) -> Void) {
       // networkAgent.getSimilarMovieById(id: id, completion: completion)
        networkAgent.getSimilarMovieById(id: id) { result in
            switch result {
            case .success(let data):

                self.movieRepository.saveSimilarContent(id: id, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getSimilarContent(id: id) {
                completion(.success($0))
                print("similar content :\($0)")
            }
        }
    }

    func getCreditById(id: Int, completion: @escaping (MDBResult<CreditList>) -> Void) {
       // networkAgent.getCreditById(id: id, completion: completion)
        networkAgent.getCreditById(id: id) { creditListResult in
            switch creditListResult {
            case .success(let creditList):
                self.movieRepository.saveCasts(id: id, data: creditList)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getCasts(id: id) { creditList in
                completion(.success(creditList))
            }
        }
    }

    func getMovieDetailById(id: Int, completion: @escaping (MDBResult<MovieDetail>) -> Void) {
        //networkAgent.getMovieDetailById(id: id, completion: completion)
        
        networkAgent.getMovieDetailById(id: id) { (result) in
            
            switch result {
            case .success(let movieDetail):
                self.movieRepository.saveDetail(data: movieDetail)
            case .failure(let error):
                print("\(#function) \(error)")
                
            }
            
            self.movieRepository.getDetail(id: id) { (item) in
                if let item = item {
                    completion(.success(item))
                }else {
                    completion(.failure("failed to get detail with id \(id)"))
                }
            }
        }
    }

    

    
}
