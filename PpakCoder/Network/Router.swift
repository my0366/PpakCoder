//
//  Router.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    // MARK: - Cases
    case login(email : String, password : String)
    case register(name : String, email : String, password : String)
    case getAllPost(page : Int, order_by : String, per_page : Int, status : String)
    case getPostDetail(id : Int)
    // MARK: - Methods
    var method: HTTPMethod {
        switch self {
        case .getAllPost, .getPostDetail:
            return .get
        case .login, .register:
            return .post
        }
    }
    
    // MARK: - Paths
    var path: String {
        switch self {
        case .getAllPost:
            return "/posts"
        case .login:
            return "/user/login"
        case .register:
            return "/user/register"
        case .getPostDetail(let id):
            return "/posts/\(id)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getAllPost(let page, let order_by, let per_page,let status):
            return ["page" : page
                    ,"order_by" : order_by
                    ,"per_page" :per_page
                    ,"status" : status]
        case .login(let email, let password):
            return ["email": email
                    ,"password": password]
        case .register(let name, let email, let password):
            return ["name" : name
                    ,"email" : email
                    ,"password" : password]
        case .getPostDetail(id: let id):
            return nil
        }
    }
    
    // MARK: - Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .login, .register:
            return JSONEncoding.default
        default:
            return URLEncoding(destination: .queryString)
        }
    }
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        let url = Constants.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.method = method
        
        // Common Headers
//        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
//        urlRequest.setValue("aplication/json", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}

