//
//  TodoRouter.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/11.
//

import Foundation
import Alamofire

enum TodoRouter: URLRequestConvertible {
    // MARK: - Cases

    case getAllTodo(page : Int, order_by : String, per_page : Int)
    case uploadTodo(title : String, is_done : Bool)
    // MARK: - Methods
    var method: HTTPMethod {
        switch self {
        case .getAllTodo:
            return .get
        case .uploadTodo:
            return .post
        }
    }
    
    // MARK: - Paths
    var path: String {
        switch self {
        case .getAllTodo, .uploadTodo:
            return "/todos"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getAllTodo(let page, let order_by, let per_page):
            return ["page" : page
                    ,"order_by" : order_by
                    ,"per_page" :per_page]
        case .uploadTodo:
            return nil
        }
    }
    
    // MARK: - Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .getAllTodo:
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var multipartFormData: MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case .uploadTodo(let title, let is_done):
            multipartFormData.append(title.data(using: .utf8) ?? Data(), withName: "title")
            multipartFormData.append("\(is_done)".data(using: .utf8) ?? Data() , withName: "is_done")
        default: ()
            
        }
    
        return multipartFormData
    }
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        let url = Constants.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.method = method
        
        
        // Common Headers
//        xurlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        //        urlRequest.setValue("aplication/json", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        // Parameters
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}


