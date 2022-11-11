//
//  User.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/03.
//

import Foundation

struct LoginData : Codable {
    
    var data : UserData?
    var message : String
}

struct UserData : Codable {
    var user : LoginUser
    var token : Token
}

struct LoginUser : Codable, Hashable {
    var id : Int
    var name : String
    var email : String
    var post_count : Int
    var avatar : String
}

struct Token : Codable, Hashable {
    var token_type : String
    var expires_in : Int
    var access_token : String
    var refresh_token : String
}
