//
//  MovieViewModel.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 01/09/2023.
//

import Foundation
import RxSwift
import RxCocoa
class MovieViewModel {
    //observables
    let homeItemList = BehaviorRelay<[HomeMovieSectionModel]>(value: [])
    private var observablePopularMovies = BehaviorRelay<[Result]>(value: [])
    private var observableTopRatedMovies = BehaviorRelay<[Result]>(value: [])
    private var observableUpcomingMovies = BehaviorRelay<[Result]>(value: [])
    private var observableActorList = BehaviorRelay<[ActorInfo]>(value: [])
    private var observablePopularSeries = BehaviorRelay<[Result]>(value: [])
    private var observableGenreList = BehaviorRelay<[MovieGenre]>(value: [])
    
    
    //models
    private let movieModel = RxMovieModelImpl.shared
   
    private let disposeBag = DisposeBag()
    
    init() {
        initObserver()
    }
    
    private func initObserver() {
        Observable.combineLatest(observableActorList,observableGenreList,observablePopularMovies,observablePopularSeries,observableUpcomingMovies,observableTopRatedMovies)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe{ (
                actorList,
                genreList,
                popularMovies,
                popularSeries,
                upcomingMovies,
                topRatedMovies
                
                
              
            ) in
                var items = [HomeMovieSectionModel] ()
                
                
                if !actorList.isEmpty {
                    var actorDataList = ActorList()
                    actorDataList.results = actorList
                    items.append(HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: actorDataList)]))
                }
                
                
                if !genreList.isEmpty {
                    items.append(HomeMovieSectionModel.genreResult(items: [.movieGenreSection(items: genreList)]))
                }
                
                if !popularMovies.isEmpty {
                    var popularMovieList = MovieList()
                    popularMovieList.results = popularMovies
                    items.append(HomeMovieSectionModel.movieResult(items: [.popularMoviesSection(items: popularMovieList)]))
                }
                
                if !popularSeries.isEmpty {
                    var popularSeriesList = MovieList()
                    popularSeriesList.results = popularSeries
                    items.append(HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: popularSeries)]))
                }
                
                if !upcomingMovies.isEmpty {
                    var upcomingMovieList = MovieList()
                    upcomingMovieList.results = upcomingMovies
                    items.append(HomeMovieSectionModel.movieResult(items: [.upcomingMoviesSection(items: upcomingMovieList)]))
                }
                
                if !topRatedMovies.isEmpty {
                    var topRatedMovieList = MovieList()
                    topRatedMovieList.results = topRatedMovies
                    items.append(HomeMovieSectionModel.movieResult(items: [.showcaseMoviesSection(items: topRatedMovieList)]))
                }
                
                self.homeItemList.accept(items)
                
            }.disposed(by: disposeBag)
    }
    
    func handlePullToRefresh() {
        fetchAllData()
    }

    
    func fetchAllData() {
        getPopularMovieList()
        getPopularSeriesList()
        getTopRatedMovieList()
        getUpcomingMovieList()
        getPopularPeople()
        getGenreList()
    }
    
    func getPopularMovieList() {
        movieModel.getPopularMovieList()
            .subscribe(onNext: {self.observablePopularMovies.accept($0.results ?? [])})
            .disposed(by: disposeBag)
    }
    
    func getPopularSeriesList() {
        movieModel.getPopularSeriesList()
            .subscribe(onNext: {self.observablePopularSeries.accept($0.results ?? [])})
            .disposed(by: disposeBag)
    }
    
    func getTopRatedMovieList() {
        movieModel.getTopRatedMovieList(page: 1)
            .subscribe(onNext: {self.observableTopRatedMovies.accept($0.results ?? [])})
            .disposed(by: disposeBag)
    }
    func getUpcomingMovieList() {
        movieModel.getUpcomingMovieList()
            .subscribe(onNext: {self.observableUpcomingMovies.accept($0.results ?? [])})
            .disposed(by: disposeBag)
    }
    func getPopularPeople() {
        movieModel.getPopularPeopleList()
            .subscribe(onNext: {self.observableActorList.accept($0.results ?? [])})
            .disposed(by: disposeBag)
    }
    func getGenreList() {
        movieModel.getGenreList()
            .subscribe(onNext: {self.observableGenreList.accept($0.genres ?? [])})
            .disposed(by: disposeBag)
    }
}
