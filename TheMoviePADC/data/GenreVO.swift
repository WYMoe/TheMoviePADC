//
//  GenreVO.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 08/04/2023.
//

import Foundation
class GenreVO {
    var id:Int = 0
    var name:String="ACTION"
    var isSelected:Bool=false
    
    init(id:Int,name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
