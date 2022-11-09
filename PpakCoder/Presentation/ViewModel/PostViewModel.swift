//
//  PostViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class PostViewModel {
        
    static let postDetailNotificationName = "postDetailNotification"
    let disposeBag = DisposeBag()
    
    init() {
        print(#fileID, #function, #line, "- ")
        fetchTodosWithObservable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPostDetail(_:)), name: Notification.Name(rawValue: PostViewModel.postDetailNotificationName), object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PostViewModel.postDetailNotificationName), object: nil)
    }
    
    @objc fileprivate func getPostDetail(_ notification: NSNotification) {
        getPostDetail(id : notification.object as! Int)
    }
    
    var alertEvent = PublishSubject<MsgType>()
    
    var postData = BehaviorRelay<[PostData]>(value: [])
    
    var postDetailData = PublishSubject<[PostData]>()
    
    @Published var meta : MetaData? = nil
    
    @Published var errMsg : String? = nil
    
    @Published var isLoading : Bool = false
    
    
    fileprivate func submitData(meta: MetaData, data: [PostData]){
        
        DispatchQueue.main.async {
            self.meta = meta
            self.errMsg = nil
            self.postData.accept(data)
            self.isLoading = false
        }
    }
    
    func fetchTodosWithObservable() {
        print(#fileID, #function, #line, "- fetchTodosWithObservable")
        Service.shared.getMainPageData()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                let meta = result.meta,
                let data = result.data else {
                    return
                }
                self.submitData(meta: meta, data: data)
            }, onError: { [weak self] err in
                guard let self = self,
                      let apiError = err as? ApiError else {
                    return
                }
                self.handleError(apiError)
            })
            .disposed(by: disposeBag)
    }
    
    func getPostDetail(id : Int) {
        Service.shared.getDetailPageData(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {
                    return
                }
                self.postDetailData.onNext(result)
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
            
            self.isLoading = false
            
            self.errMsg = failure.info
            self.alertEvent.onNext(MsgType.error)
            switch failure {
//            case .noContent:
//                self.todos = []
            default: break
            }
        }
    }
    
}
