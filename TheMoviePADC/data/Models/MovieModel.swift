//
//  MovieModel.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 15/06/2023.
//

import Foundation


protocol MovieModel{
    
    //movies
    func getPopularPeople ( page:Int?, completion:@escaping(MDBResult<ActorList>)->Void)
    func getTopRatedMovieList(completion:@escaping(MDBResult<MovieList>)->Void)
    func getGenreList(completion:@escaping(MDBResult<MovieGenreList>)->Void)
    func getPopularSeriesList(completion:@escaping(MDBResult<MovieList>)->Void)
    func getPopularMovieList(completion:@escaping(MDBResult<MovieList>)->Void)
    func getUpcomingMovieList(completion:@escaping(MDBResult<MovieList>)->Void)
}


class MovieModelImpl : BaseModel, MovieModel{
    
     static let shared = MovieModelImpl()
     private override init() {
        
    }
    
  

    func getTopRatedMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
        networkAgent.getTopRatedMovieList(completion: completion)
    }
    
    
    func getPopularMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
        networkAgent.getPopularMovieList(completion: completion)
    }
    
    
    func getUpcomingMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
        networkAgent.getUpcomingMovieList(completion: completion)
    }
    
    
    func getGenreList(completion:@escaping(MDBResult<MovieGenreList>)->Void){
        networkAgent.getGenreList(completion: completion)
    }
    
    
    func getPopularPeople ( page:Int?, completion:@escaping(MDBResult<ActorList>)->Void){
        networkAgent.getPopularPeople(page: page, completion: completion)
    }
    
    func getPopularSeriesList(completion:@escaping(MDBResult<MovieList>)->Void){
        networkAgent.getPopularSeriesList(completion: completion)
    }

}

