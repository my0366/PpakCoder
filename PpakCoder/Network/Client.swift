//
//  Service.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import Alamofire
import RxSwift
class Client {
    
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: Error) -> Void)
    
    
    //Object : Model, router : Router에 요청할 함수, (success, failure) -> 클로저로 성공,실패시 Network요청시 받아온 데이터 탈출
    static func request<T>(_ object: T.Type,
                               router: Router,
                               success: @escaping onSuccess<T>,
                               failure: @escaping onFailure) where T: Decodable  {
            session.request(router)
                .validate(statusCode: 200..<500)
                .responseDecodable(of: object) { response in
                    switch response.result {
                    case .success:
                        guard let decodedData = response.value else { return }
                        success(decodedData)
                    case .failure(let err):
                        failure(err)
                    }
                }
        }
    
    
}
