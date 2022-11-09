//
//  Service.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/09.
//

import Foundation
import Alamofire
import RxSwift

struct BaseListResponse<T: Codable>: Codable {
    let data: [T]?
    let meta: MetaData?
    let message: String?
//    let hey : String
}
enum MsgType : String {
    case success = "성공"
    case error = "에러"
}


class Service {
    
    static let shared = Service()
    
    func getMainPageData() -> Observable<Post> {
        return Observable.create { observer in
            Client.request(Post.self, router: Router.getAllPost(page: 1, order_by: "desc", per_page: 10, status: "all")) { data in
                observer.onNext(data)
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func getDetailPageData(id : Int) -> Observable<[PostData]> {
        return Observable.create { observer in
            Client.request(Post.self
                           , router: Router.getPostDetail(id: id)) { data in
                guard let result = data.data else {
                    return
                }
                observer.onNext(result)
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}
