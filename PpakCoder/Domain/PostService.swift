//
//  Service.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/09.
//

import Foundation
import Alamofire
import RxSwift

enum MsgType : String {
    case success = "성공"
    case error = "에러"
}


class PostService {
    
    static let shared = PostService()
    
    func getMainPageData(page: Int, order_by: String, per_page: Int, status: String) -> Observable<Post> {
        return Observable.create { observer in
            Client.request(Post.self, router: PostRouter.getAllPost(page: page, order_by: order_by, per_page: per_page, status: status)) { data in
                observer.onNext(data)
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func getDetailPageData(id : Int) -> Observable<PostData> {
        return Observable.create { observer in
            Client.request(PostDetail.self, router: PostRouter.getPostDetail(id: id)) { data in
                if let post = data.data {
                    observer.onNext(post)
                } else {
                    print("error")
                }
            } failure: { error in
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func uploadPost(uploadData : Upload) -> Observable<PostData> {
        
        let data = PostRouter.uploadPost(uploadData)
        return Observable.create { observer in
            AF.upload(multipartFormData: data.multipartFormData, with: data, interceptor: RequireToken()).responseDecodable(of : PostDetail.self) { res in
                switch res.result {
                case .success:
                    self.getMainPageData(page: 1, order_by: "desc", per_page: 10, status: "published").subscribe { data in
                        if let update = data.element {
                            update.data?.forEach({ list in
                                observer.onNext(list)
                            })
                        }
                    }.disposed(by: DisposeBag())
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}

