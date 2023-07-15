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
    private override init() {   }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    
    var totalPageActorList : Int? = 1
    
    
    
    
    func getUpcomingMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
       // networkAgent.getUpcomingMovieList(completion: completion)
        
        networkAgent.getUpcomingMovieList{ (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")

            }

            self.contentTypeRepository.getMoviesOrSeries(type: .upcomingMovies, completion:{ movieList in

                completion(.success(movieList))
            })


        }
        
        
        
    }
    
    func getPopularMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
       // networkAgent.getPopularMovieList(completion: completion)
        
        networkAgent.getPopularMovieList{ (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .popularMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")

            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .popularMovies, completion:{ movieList in
            
                completion(.success(movieList))
            })


        }
    }
    
    
    func getPopularSeriesList(completion:@escaping(MDBResult<MovieList>)->Void){
           // networkAgent.getPopularSeriesList(completion: completion)
            
            networkAgent.getPopularSeriesList{ (result) in
                switch result {
                case .success(let data):
                    self.movieRepository.saveList(type: .pupularSeries, data: data)
                    self.totalPageActorList = data.totalPages ?? 1
                case .failure(let error):
                    print("\(#function) \(error)")
                    
                }
                
                self.contentTypeRepository.getMoviesOrSeries(type: .pupularSeries, completion:{ movieList in
                    completion(.success(movieList))
                })
              
                
            }
        }
    
        
         // movie showcase
    func getTopRatedMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
        //networkAgent.getTopRatedMovieList(completion: completion)
        
        
        networkAgent.getTopRatedMovieList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .topRatedMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")

            }

            self.contentTypeRepository.getMoviesOrSeries(type: .topRatedMovies, completion:{ movieList in
               
                completion(.success(movieList))
            })



        }
    }
    
    
   
    
  

    func getGenreList(completion:@escaping(MDBResult<MovieGenreList>)->Void){
           //networkAgent.getGenreList(completion: completion)

        networkAgent.getGenreList { (result) in
            switch result {
            case .success(let data):
                self.genreRepository.save(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
          
            self.genreRepository.get(completion : {
                movieGenreList in completion(.success(movieGenreList)) })

        }
    }
        
        
    func getPopularPeople ( page:Int?, completion:@escaping(MDBResult<ActorList>)->Void){
           // networkAgent.getPopularPeople(page: page, completion: completion)
        
        networkAgent.getPopularPeople(page: page) { result in
            switch result {
            case .success(let actorList):
                self.movieRepository.savePopularActorList(list: actorList)
                self.totalPageActorList = actorList.totalPages ?? 1
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.movieRepository.getPopularActorList(page: page ?? 1) { actorList in
                completion(.success(actorList))
            }
        }
        
        }
    
    
    
        
   
    
    
}
