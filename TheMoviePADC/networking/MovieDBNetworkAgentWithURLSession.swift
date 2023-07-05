////
////  MovieDBNetworkAgentWithURLSession.swift
////  TheMoviePADC
////
////  Created by Wai Yan Moe on 15/06/2023.
////
//
//import Foundation
//
//class MovieDBNetworkAgentWithURLSession : MovieDBNetworkAgentProtocol {
//    func getSimilarSeriesById(id: Int, completion: @escaping (MDBResult<MovieList>) -> Void) {
//        
//    }
//    
//    func getSeriesCreditById(id: Int, completion: @escaping (MDBResult<CreditList>) -> Void) {
//        
//    }
//    
//    func getSeriesDetailById(id: Int, completion: @escaping (MDBResult<MovieDetail>) -> Void) {
//        
//    }
//    
//    
//    static let shared = MovieDBNetworkAgentWithURLSession()
//    init() {
//        
//    }
//    func getMovieTrailersById(id: Int, completion: @escaping (MDBResult<MovieTrailerList>) -> Void) {
//        
//    }
//    
//    func getSimilarMovieById(id: Int, completion: @escaping (MDBResult<MovieList>) -> Void) {
//        
//    }
//    
//    func getCreditById(id: Int, completion: @escaping (MDBResult<CreditList>) -> Void) {
//        
//    }
//    
//    func getPopularPeople(page: Int?, completion: @escaping (MDBResult<ActorList>) -> Void) {
//        
//    }
//    
//    func getMovieDetailById(id: Int, completion: @escaping (MDBResult<MovieDetail>) -> Void) {
//        
//    }
//    
//    func getTopRatedMovieList(completion: @escaping (MDBResult<MovieList>) -> Void) {
//        
//    }
//    
//    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
//        let url = URL(string: "\(AppConstants.baseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)")
//        var urlRequest = URLRequest(url: url!)
//        urlRequest.httpMethod = "GET"
//        
//        let session = URLSession.shared
//        session.dataTask(with: urlRequest){ data,response,error in
//            let genreList : MovieGenreList = try! JSONDecoder().decode(MovieGenreList.self, from: data!)
//            print(genreList.genres?.count as Any)
//            
//            
//        }.resume()
//        
//        
//      
//        
//    }
//    
//    func getPopularSeriesList(completion: @escaping (MDBResult<MovieList>) -> Void) {
//        
//    }
//    
//    func getPopularMovieList(completion: @escaping (MDBResult<MovieList>) -> Void) {
//        
//    }
//    
//    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieList>) -> Void) {
//        
//    }
//    
//    
//}
