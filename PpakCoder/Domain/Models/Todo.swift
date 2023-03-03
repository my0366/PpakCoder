//
//  Todo.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/11.
//

import Foundation

struct Todo : Codable {
    var data : [TodoData]?
    var message : String
}

struct TodoData : Codable, Hashable {
    var id : Int
    var title : String
    var is_done : Bool
    var created_at : String
    var updated_at : String
}

struct TodoResponse : Codable {
    var data : TodoData?
    var message : String
}
