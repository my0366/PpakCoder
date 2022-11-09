//
//  Post.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation

struct Post : Codable {
    var data : [PostData]?
    var meta : MetaData?
    var message : String
}

struct PostData : Codable, Hashable {
    var id : Int
    var title : String
    var content : String
    var images : [Image]
    var is_published : Bool
    var user_id : Int?
    var created_at : String
    var updated_at : String?
}

struct Image : Codable, Hashable {
    var id : Int?
    var url : String?
}

struct MetaData: Codable, Hashable {
    var current_page : Int
    var from : Int
    var last_page : Int
    var per_page : Int
    var to : Int
    var total : Int
}
