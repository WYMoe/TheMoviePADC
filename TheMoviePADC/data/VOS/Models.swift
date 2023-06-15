//
//  Models.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 06/06/2023.
//


import Foundation

struct LoginRequest: Codable {
    let username : String?
    let password : String?
    let requestToken : String?
    enum CodingKeys : String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
        
    }
    

}

struct TokenResponseAndLoginSuccess : Codable {
    let success : Bool?
    let requestToken : String?
    let expiresAt :String?
    
    enum CodingKeys : String, CodingKey {
        case success
        case requestToken = "request_token"
        case expiresAt = "expires_at"
        
    }
    
    
}
struct LoginFailed : Codable {
    let success : Bool?
    let statusCode : Int?
    let statusMessage :String?
    enum CodingKeys : String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
        
    }
}

struct MovieGenre : Codable {
    let id:Int
    let name:String
    enum CodingKeys : String, CodingKey {
        case id
        case name
    }
    func convertToGenreVO()->GenreVO{
        let vo = GenreVO(id: id, name: name, isSelected: false)
        return vo
    }
}


struct MovieGenreList : Codable {
    let genres : [MovieGenre]?
    enum CodingKeys : String, CodingKey {
        case genres
    }
   
}
