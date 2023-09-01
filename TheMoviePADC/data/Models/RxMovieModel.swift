//
//  RxMovieModel.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 20/08/2023.
//

import Foundation
import RxSwift
import RxCocoa
protocol RxMovieModel {
    func getTopRatedMovieList(page :Int) -> Observable<MovieList>
    func getPopularMovieList() -> Observable<MovieList>
    func getUpcomingMovieList() -> Observable<MovieList>
    func getPopularPeopleList() -> Observable<ActorList>
    func getGenreList() -> Observable<MovieGenreList>
    func getPopularSeriesList() -> Observable<MovieList>
}

class RxMovieModelImpl : BaseModel, RxMovieModel {
    
  
  
    
    
    
    static let shared : RxMovieModel = RxMovieModelImpl()
    
    private override init() {
        
    }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    let disposebag = DisposeBag()
    
    
 
    
    func getTopRatedMovieList(page: Int) -> Observable<MovieList> {
        /**
         show from db first
         make network request
         - success -> update db -> notify/push -> update UI
         - fail -> xxx
         */
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getTopRatedMovieList(page: page )
        observableRemoteMovieList
            .subscribe(onNext: {
                data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposebag)
        
        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getwithRx(type: .popularMovies)
        return observableLocalMovieList
        
    }
    func getPopularMovieList() -> Observable<MovieList> {
        
        /**
         show from db first
         make network request
         - success -> update db -> notify/push -> update UI
         - fail -> xxx
         */
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getPopularMovieList()
        observableRemoteMovieList
            .subscribe(onNext: {
                data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposebag)
        
        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getwithRx(type: .popularMovies)
        return observableLocalMovieList
        

//        return RxNetworkAgent.shared.getPopularMovieList()
//            .do(onNext: {
//                movieList in
//                self.movieRepository.saveList(type: .popularMovies, data: movieList)
//
//
//            })
//            .flatMap { _ -> Observable<MovieList> in
//                return Observable.create { observer -> Disposable in
//                    self.contentTypeRepository.getMoviesOrSeries(type: .popularMovies) { movieList in
//                        observer.onNext(movieList)
//                        observer.onCompleted()
//                    }
//                    return Disposables.create()
//                }
//            }
    }
    
    func getPopularSeriesList() -> Observable<MovieList> {
        
        /**
         show from db first
         make network request
         - success -> update db -> notify/push -> update UI
         - fail -> xxx
         */
        let observableRemoteMovieList = RxNetworkAgent.shared.getPopularSeriesList()
        observableRemoteMovieList
            .subscribe(onNext: {
                data in
                self.movieRepository.saveList(type: .pupularSeries, data: data)
            })
            .disposed(by: disposebag)
        
        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getwithRx(type: .pupularSeries)
        return observableLocalMovieList
        
    }
    
    func getUpcomingMovieList() -> Observable<MovieList> {
        /**
         show from db first
         make network request
         - success -> update db -> notify/push -> update UI
         - fail -> xxx
         */
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getUpcomingMovieList()
        observableRemoteMovieList
            .subscribe(onNext: {
                data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposebag)
        
        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getwithRx(type: .popularMovies)
        return observableLocalMovieList
        
    }
    
    
    func getPopularPeopleList() -> Observable<ActorList> {
        /**
         show from db first
         make network request
         - success -> update db -> notify/push -> update UI
         - fail -> xxx
         */
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getPopularPeopleList()
        observableRemoteMovieList
            .subscribe(onNext: {
                data in
                self.movieRepository.savePopularActorList(list: data)
            })
            .disposed(by: disposebag)
        
        let observableLocalMovieList = MovieRepositoryImpl.shared.getPopularActorListwithRx()
        return observableLocalMovieList
    }
    
    
    func getGenreList() -> RxSwift.Observable<MovieGenreList> {
        /**
         show from db first
         make network request
         - success -> update db -> notify/push -> update UI
         - fail -> xxx
         */
        
        let observableRemoteMovieList = RxNetworkAgent.shared.getGenreList()
        observableRemoteMovieList
            .subscribe(onNext: {
                data in
                self.genreRepository.save(data: data)
            })
            .disposed(by: disposebag)
        
        let observableLocalMovieList = GenreRepositoryImpl.shared.getGenreListWithRx()
        return observableLocalMovieList
    }
    
}
