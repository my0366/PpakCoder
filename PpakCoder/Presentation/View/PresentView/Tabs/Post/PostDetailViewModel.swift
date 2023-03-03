//
//  PostDetailViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class PostDetailViewModel {

    let disposeBag = DisposeBag()
    
    
    init() {
        print(#fileID, #function, #line, "- ")
//        getPostDetail(id)
    }
    
    var alertEvent = PublishSubject<MsgType>()
    
    var postData = BehaviorRelay<[PostData]>(value: [])
    
    var postDetailData = BehaviorRelay<PostData>(value: PostData(id: 0, title: "", content: "", images: [], is_published: true, user_id: 0, created_at: "", updated_at: ""))
    
    @Published var errMsg : String? = nil
    
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value : false)
    
    fileprivate func submitData(data: PostData){
        DispatchQueue.main.async {
            self.errMsg = nil
            self.postDetailData.accept(data)
            self.isLoading.accept(false)
        }
    }
    
    func getPostDetail(id : Int) {
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        PostService.shared.getDetailPageData(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self
                else {
                    return
                }
                self.submitData(data: result)
            }, onError: { [weak self] err in
                guard let self = self,
                      let apiError = err as? ApiError else {
                    return
                }
                self.handleError(apiError)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func handleError(_ failure: ApiError){
        print(#fileID, #function, #line, "- handleError: \(failure)")
        
        DispatchQueue.main.async {
            
            self.isLoading.accept(false)
            
            self.errMsg = failure.info
            self.alertEvent.onNext(MsgType.error)
            switch failure {
            default: break
            }
        }
    }
}
