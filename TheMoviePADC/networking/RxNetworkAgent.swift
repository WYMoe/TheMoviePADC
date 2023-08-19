//
//  RxNetworkAgent.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 18/08/2023.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum MDBEror : Error {
    case withMessage(String)
}

class RxNetworkAgent {
    static let shared = RxNetworkAgent()
   
    
    func getPopularMovieList() -> Observable<MovieList> {
        
//        let url =  " \(AppConstants.baseURL)/3/movie/popular?language=en-US&page=1&api_key=3c1df4e11dda694c743d0bfd1ab8d"
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.popularMovie(1))
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
        
// behind the secene
//        return Observable.create { observer in
//            AF.request(MDBEndpoint.popularMovie(1))
//                .responseDecodable(of: MovieList.self) { response in
//                    switch response.result {
//                    case .success(let data):
//                        observer.onNext(data)
//                        observer.onCompleted()
//                    case .failure(let error):
//                        observer.onError(error)
//                    }
//                }
//            return Disposables.create()
//        }
    }
    
    
    func getTopRatedMovieList(page : Int) -> Observable<MovieList> {
        
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.topratedMovies(page))
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
    }
    
    func getUpcomingMovieList() -> Observable<MovieList> {
        
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.upcomingMovie(1))
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
    }
    
    func getPopularPeopleList() -> Observable<ActorList> {
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.popularActors(1))
            .flatMap { item -> Observable<ActorList> in
                Observable.just(item.1)
            }
    }
    
}
