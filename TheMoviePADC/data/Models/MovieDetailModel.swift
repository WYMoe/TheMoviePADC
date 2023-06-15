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
    func getSeriesDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void)

    
}

class MovieDetailModelImpl : BaseModel,MovieDetailModel {
        
    
    static let shared = MovieDetailModelImpl()
    private override init() {
       
   }
    
    func getMovieTrailersById(id: Int, completion: @escaping (MDBResult<MovieTrailerList>) -> Void) {
        networkAgent.getMovieTrailersById(id: id, completion: completion)
    }

    func getSimilarMovieById(id: Int, completion: @escaping (MDBResult<MovieList>) -> Void) {
        networkAgent.getSimilarMovieById(id: id, completion: completion)
    }

    func getCreditById(id: Int, completion: @escaping (MDBResult<CreditList>) -> Void) {
        networkAgent.getCreditById(id: id, completion: completion)
    }

    func getMovieDetailById(id: Int, completion: @escaping (MDBResult<MovieDetail>) -> Void) {
        networkAgent.getMovieDetailById(id: id, completion: completion)
    }

    func getSeriesDetailById(id: Int, completion: @escaping (MDBResult<MovieDetail>) -> Void) {
        networkAgent.getSeriesDetailById(id: id, completion: completion)
    }

    
}
