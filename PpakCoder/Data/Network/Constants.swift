//
//  Constants.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation

struct Constants {
     // MARK: - Base URL
     static var baseURL: URL {
         return URL(string: "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v1")!
     }

     static let token = ""
 }

 enum HTTPHeaderField: String {
     case authentication = "Authorization"
     case contentType = "Content-Type"
     case acceptType = "Accept"
     case acceptEncoding = "Accept-Encoding"
     case xAuthToken = "x-auth-token"
 }

 enum ContentType: String {
     case json = "application/json"
 }
