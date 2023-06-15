//
//  SeriesDetailModel.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 16/06/2023.
//

import Foundation


protocol SeriesDetailModel {
    func getSeriesDetailById ( id: Int, completion:@escaping(MDBResult<MovieDetail>)->Void)
    func getSimilarSeriesById ( id: Int, completion:@escaping(MDBResult<MovieList>)->Void)
    func getSeriesCreditById ( id: Int, completion:@escaping(MDBResult<CreditList>)->Void)

    
}

class SeriesDetailModelImpl : BaseModel,SeriesDetailModel {
   
  
        
    
    static let shared = SeriesDetailModelImpl()
    private override init() {
       
   }
    
   
    func getSeriesDetailById(id: Int, completion: @escaping (MDBResult<MovieDetail>) -> Void) {
        networkAgent.getSeriesDetailById(id: id, completion: completion)
    }
    
    func getSimilarSeriesById(id: Int, completion: @escaping (MDBResult<MovieList>) -> Void) {
        networkAgent.getSimilarSeriesById(id: id, completion: completion)
    }
    
    func getSeriesCreditById(id: Int, completion: @escaping (MDBResult<CreditList>) -> Void) {
        networkAgent.getSeriesCreditById(id: id, completion: completion)
    }
    
    
}
