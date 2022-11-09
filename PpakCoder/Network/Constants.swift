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
enum MyError : String, Error {
    case urlNotFound = "url을 찾을 수 없습니다."
}

enum ApiError : Error {
    case notExist
    case badStatus(_ code: Int)
    case unauthorized
    case noMoreContent
    case noContent
    case tooManyRequest
    case decodingError
    case noRequestContent
    case unknown(_ error : Error?)
//    case serverError(_ error : ErrorResponse?)
    
    var info : String {
        switch self {
        case .notExist:             return "컨텐츠가 존재하지 않습니다"
        case .badStatus(let code):  return "상태 코드 : \(code)"
        case .decodingError:        return "디코딩 에러입니다"
        case .unauthorized:         return "인증되지 않은 사용자입니다"
        case .noMoreContent:        return "더 이상 가져올 데이터가 없습니다"
        case .noContent:            return "컨텐츠가 없습니다."
        case .tooManyRequest:       return "짧은 시간에 너무 많은 요청이 있습니다. 잠시후에 시도해주세요"
        case .noRequestContent:     return "내용을 입력해주세요"
//        case .serverError(let err): return err?.message ?? ""
        case .unknown(let err):     return "알 수 없는 에러입니다 \(String(describing: err?.localizedDescription))"
        }
    }
}
