//
//  NetworkingAgent.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/06/2023.
//

import Foundation
import Alamofire

struct MovieDBNetworkAgent{
    static let shared = MovieDBNetworkAgent()
    private init(){
        
    }
    
func getMovieTrailersById( id: Int, success:@escaping(MovieTrailerList)->Void, failure:@escaping(String)->Void) {
    
    let url = URL(string: "\(AppConstants.baseURL)/movie/\(id)/videos?api_key=\(AppConstants.apiKey)")!
    AF.request(url)
        .validate()
        .responseDecodable(of:MovieTrailerList.self) { response in
            
        
            switch response.result {
        case .success(let movieTrailerList):
            success(movieTrailerList)
        case .failure(let error):
            failure(error.errorDescription!)
            
        }
    }
    
}
    
    func getSimilarMovieById ( id: Int, success:@escaping(MovieList)->Void, failure:@escaping(String)->Void) {
        
        let url = URL(string: "\(AppConstants.baseURL)/movie/\(id)/similar?api_key=\(AppConstants.apiKey)")!
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
            
                switch response.result {
            case .success(let movieList):
                success(movieList)
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
        
    }
    
     func getCreditById ( id: Int, success:@escaping(CreditList)->Void, failure:@escaping(String)->Void) {
         
         let url = URL(string: "\(AppConstants.baseURL)/movie/\(id)/credits?api_key=\(AppConstants.apiKey)")!
         AF.request(url)
             .validate()
             .responseDecodable(of:CreditList.self) { response in
                 
             
                 switch response.result {
             case .success(let creditList):
                 success(creditList)
             case .failure(let error):
                 failure(error.errorDescription!)
                 
             }
         }
         
     }
     
     
     

    func getPopularPeople ( page:Int?, success:@escaping(ActorList)->Void, failure:@escaping(String)->Void) {
        
        let url = URL(string: "\(AppConstants.baseURL)/person/popular?page=\(page ?? 1)&api_key=\(AppConstants.apiKey)")!
        AF.request(url)
            .validate()
            .responseDecodable(of:ActorList.self) { response in
                
        //        print(response.result)
                switch response.result {
            case .success(let actorList):
                success(actorList)
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
        
    }
    
   
    func getMovieDetailById ( id: Int, success:@escaping(MovieDetail)->Void, failure:@escaping(String)->Void) {
        
        let url = URL(string: "\(AppConstants.baseURL)/movie/\(id)?api_key=\(AppConstants.apiKey)")!
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieDetail.self) { response in
                
            
                switch response.result {
            case .success(let movieDetail):
                success(movieDetail)
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
        
    }
    
    
    
    

    
    func getTopRatedMovieList(success:@escaping(MovieList)->Void, failure:@escaping(String)->Void){
        let url = URL(string: "\(AppConstants.baseURL)/movie/top_rated?api_key=\(AppConstants.apiKey)")!
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
            
                switch response.result {
            case .success(let topRatedMovieList):
                success(topRatedMovieList)
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
    }
    func getGenreList(success:@escaping(MovieGenreList)->Void, failure:@escaping(String)->Void){
        let url = URL(string: "\(AppConstants.baseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)")!
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieGenreList.self) { response in
                
            
                switch response.result {
            case .success(let movieGenreList):
                success(movieGenreList)
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
    }
    func getPopularSeriesList(success:@escaping(MovieList)->Void, failure:@escaping(String)->Void){
        
        let url = URL(string: "\(AppConstants.baseURL)/tv/popular?api_key=\(AppConstants.apiKey)")!
        
        
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieList.self) { response in
           
            
            switch response.result {
            case .success(let popularMovieList):
                success(popularMovieList)
                
               
                
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
        
        
    }
    
   
    func getPopularMovieList(success:@escaping(MovieList)->Void, failure:@escaping(String)->Void){
        
        let url = URL(string: "\(AppConstants.baseURL)/movie/popular?api_key=\(AppConstants.apiKey)&page=1")!
        
        
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieList.self) { response in
           
            
            switch response.result {
            case .success(let popularMovieList):
                success(popularMovieList)
                
               
                
            case .failure(let error):
                failure(error.errorDescription!)
                
            }
        }
        
        
    }
    func getUpcomingMovieList(success:@escaping(MovieList)->Void, failure:@escaping(String)->Void){
        
        let url = URL(string: "\(AppConstants.baseURL)/movie/upcoming?api_key=\(AppConstants.apiKey)&page=1")!
        
        
        AF.request(url)
            .validate()
            .responseDecodable(of:MovieList.self) { response in
           
            
            switch response.result {
            case .success(let upcomingMovieList):
                success(upcomingMovieList)
                
               
            case .failure(let error):
                failure(error.errorDescription!)
              
            }
        }
        
        
    }
}
