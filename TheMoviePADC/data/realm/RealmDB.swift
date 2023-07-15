//
//  RealmDB.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 09/07/2023.
//

import Foundation
import RealmSwift
class RealmDB {
    static let shared = RealmDB()
    
    let realm = try! Realm()
    
    private init(){
        
    }
}
