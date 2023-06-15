//
//  NetworkingAgent.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/06/2023.
//

import Foundation
import Alamofire

protocol MovieDBNetworkAgentProtocol {
    
    //moviedetail
    func getMovieTrailersById( id: Int, completion:@escaping(MDBResult<MovieTrailerList>)->Void)
    func getSimilarMovieById ( id: Int, completion:@escaping(MDBResult<MovieList>)->Void)
    func getCreditById ( id: Int, completion:@escaping(MDBResult<CreditList>)->Void)
    func getMovieDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void)
    
    //seriesdetail
    func getSeriesDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void)
    func getSimilarSeriesById ( id: Int, completion:@escaping(MDBResult<MovieList>)->Void)
    func getSeriesCreditById ( id: Int, completion:@escaping(MDBResult<CreditList>)->Void)

    
    //movie
    func getPopularPeople ( page:Int?, completion:@escaping(MDBResult<ActorList>)->Void)
    func getTopRatedMovieList(completion:@escaping(MDBResult<MovieList>)->Void)
    func getGenreList(completion:@escaping(MDBResult<MovieGenreList>)->Void)
    func getPopularSeriesList(completion:@escaping(MDBResult<MovieList>)->Void)
    func getPopularMovieList(completion:@escaping(MDBResult<MovieList>)->Void)
    func getUpcomingMovieList(completion:@escaping(MDBResult<MovieList>)->Void)
}


struct MovieDBNetworkAgent: MovieDBNetworkAgentProtocol{
    func getSimilarSeriesById(id: Int, completion: @escaping (MDBResult<MovieList>) -> Void) {
        AF.request(MDBEndpoint.similarTVSeires(id))
    .validate()
    .responseDecodable(of:MovieList.self) { response in
        
        
        switch response.result {
        case .success(let movieList):
            completion(.success(movieList))
        case .failure(let error):
            completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            
        }
    }

    }
    
    func getSeriesCreditById(id: Int, completion: @escaping (MDBResult<CreditList>) -> Void) {
        AF.request(MDBEndpoint.TVCredits(id))
            .validate()
            .responseDecodable(of:CreditList.self) { response in
                
                
                switch response.result {
                case .success(let creditList):
                    completion(.success(creditList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
    }
    
    static let shared = MovieDBNetworkAgent()
    private init(){
        
    }
    
    func getMovieTrailersById( id: Int, completion:@escaping(MDBResult<MovieTrailerList>)->Void) {
        
        AF.request(MDBEndpoint.trailerVideo(id))
            .validate()
            .responseDecodable(of:MovieTrailerList.self) { response in
                
                
                switch response.result {
                case .success(let movieTrailerList):
                    completion(.success(movieTrailerList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
        
    }
    
    func getSimilarMovieById ( id: Int, completion:@escaping(MDBResult<MovieList>)->Void) {
                AF.request(MDBEndpoint.similarMovie(id))
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
                
                switch response.result {
                case .success(let movieList):
                    completion(.success(movieList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
        
    }
    
    func getCreditById ( id: Int, completion:@escaping(MDBResult<CreditList>)->Void) {
        
        AF.request(MDBEndpoint.movieActors(id))
            .validate()
            .responseDecodable(of:CreditList.self) { response in
                
                
                switch response.result {
                case .success(let creditList):
                    completion(.success(creditList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
        
    }
    
    
    
    
    func getPopularPeople ( page:Int?, completion:@escaping(MDBResult<ActorList>)->Void) {
 
        AF.request(MDBEndpoint.popularActors(page ?? 1))
            .validate()
            .responseDecodable(of:ActorList.self) { response in
                
                switch response.result {
                case .success(let actorList):
                    completion(.success(actorList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
        
    }
    
    func getSeriesDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void) {
        AF.request(MDBEndpoint.seriesDetails(id))
            .validate()
            .responseDecodable(of:MovieDetail.self) { response in
                
                
                switch response.result {
                case .success(let seriesDetailById):
                    completion(.success(seriesDetailById))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
        
    }
    
    func getMovieDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void) {
                AF.request(MDBEndpoint.movieDetails(id: id))
            .validate()
            .responseDecodable(of:MovieDetail.self) { response in
                
                
                switch response.result {
                case .success(let movieDetailById):
                    completion(.success(movieDetailById))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
        
    }
    
    
    
    
    
    
    func getTopRatedMovieList(completion:@escaping(MDBResult<MovieList>)->Void){        AF.request(MDBEndpoint.topratedMovies(1))
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
                
                switch response.result {
                case .success(let topRatedMovieList):
                    completion(.success(topRatedMovieList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
    }
    func getGenreList(completion:@escaping(MDBResult<MovieGenreList>)->Void){
        AF.request(MDBEndpoint.movieGenres)
            .validate()
            .responseDecodable(of:MovieGenreList.self) { response in
                
                
                switch response.result {
                case .success(let movieGenreList):
                    completion(.success(movieGenreList))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
                }
            }
    }
    
    
    func getPopularSeriesList(completion:@escaping(MDBResult<MovieList>)->Void){
        
        
        
        AF.request(MDBEndpoint.popularTVSeries)
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
                
                switch response.result {
                case .success(let popularSeriesList):
                    completion(.success(popularSeriesList))
                    
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
        
        
    }
    
    
    func getPopularMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
        
        
        AF.request(MDBEndpoint.popularMovie(1))
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
                
                switch response.result {
                case .success(let popularMovieList):
                    completion(.success(popularMovieList))
                    
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
        
        
    }
    func getUpcomingMovieList(completion:@escaping(MDBResult<MovieList>)->Void){
        
        AF.request(MDBEndpoint.upcomingMovie(1))
            .validate()
            .responseDecodable(of:MovieList.self) { response in
                
                
                switch response.result {
                case .success(let upcomingMovieList):
                    completion(.success(upcomingMovieList))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
        
        
    }
    
    
    fileprivate func handleError<T, E:MDBErrorModel>( _ response : DataResponse<T, AFError>, _ error: (AFError), _ errorBodyType : E.Type) -> String {
        var respBody :String = ""
        var serverErrorMessage: String?
        var errorBody : E?
        
        
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        let respCode : Int = response.response?.statusCode ?? 0
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        print( """
 ****************
 URL
 -> \(sourcePath)
 
 Status
 -> \(respCode)
 
 Body
 -> \(respBody)
 
 Underlying Error
 -> \(error.underlyingError)
 
 Error Description
 -> \(error.errorDescription)
 
 """)
        return  serverErrorMessage ?? error.errorDescription ?? "undefined"
    }
}


enum MDBResult<T> {
    case success(T)
    case failure(String)
}


protocol MDBErrorModel : Decodable {
    var message : String { get }
}


class MDBCommonResponseError : MDBErrorModel {
    var message: String {
        return statusMessage
    }
    let statusMessage  : String
    let statusCode : Int
    
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
