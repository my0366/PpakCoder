//
//  Monitor.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import Alamofire

class APIEventLogger : EventMonitor {
    
    let queue = DispatchQueue(label : "EventLogger")
    
    func requestDidFinish(_ request: Request) {
        print("🛰 NETWORK Reqeust LOG")
        print(request.description)
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
        )
    }
}


