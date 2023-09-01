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
   
    //popular movie
    func getPopularMovieList() -> Observable<MovieList> {
        
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.popularMovie(1))
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
        
// without RxAlamofire
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
    
    
    //popular series
    func getPopularSeriesList() -> Observable<MovieList> {
        
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.popularTVSeries)
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
    }
    
    
    func getTopRatedMovieList(page : Int) -> Observable<MovieList> {
        
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.topratedMovies(1))
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
    }
    
    //upcoming movie
    func getUpcomingMovieList() -> Observable<MovieList> {
        
        
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.upcomingMovie(1))
            .flatMap { item -> Observable<MovieList> in
                Observable.just(item.1)
            }
    }
 
    
    //popular people
    func getPopularPeopleList() -> Observable<ActorList> {
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.popularActors(1))
            .flatMap { item -> Observable<ActorList> in
                Observable.just(item.1)
            }
    }
    
    //genre
    
    func getGenreList() -> Observable<MovieGenreList> {
        return RxAlamofire
            .requestDecodable(.get,MDBEndpoint.movieGenres)
            .flatMap { item -> Observable<MovieGenreList> in
                Observable.just(item.1)
            }
    }
    //search movie
    func searchMovie(page : Int, query : String) -> Observable<MovieList> {
        
       return Observable.create { observer in
           AF.request(MDBEndpoint.searchMovie(page,query))
                        .responseDecodable(of: MovieList.self) { response in
                            switch response.result {
                            case .success(let data):
                                observer.onNext(data)
                               
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }
                    return Disposables.create()
                }
    }
    
}
