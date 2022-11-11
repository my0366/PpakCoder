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
    
    static let shared = PostViewModel()
    
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
    
    var postDetailData = PublishSubject<PostData>()
    
    @Published var meta : MetaData? = nil
    
    @Published var errMsg : String? = nil
    
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value : false)
    
    
    fileprivate func submitData(meta: MetaData, data: [PostData]){
        
        DispatchQueue.main.async {
            self.meta = meta
            self.errMsg = nil
            self.postData.accept(data)
            self.isLoading.accept(false)
        }
    }
    
    fileprivate func submitData(data: PostData){
        DispatchQueue.main.async {
            self.errMsg = nil
            self.postDetailData.onNext(data)
            self.isLoading.accept(false)
        }
    }
    
    func fetchTodosWithObservable() {
        print(#fileID, #function, #line, "- fetchTodosWithObservable")
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        PostService.shared.getMainPageData(page: 1, order_by: "desc", per_page: 10, status: "published")
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
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        PostService.shared.getDetailPageData(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let result = result.data
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
    
    
    
    func uploadPost(uploadData : Upload) {
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        PostService.shared.uploadPost(uploadData: uploadData)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading.accept(false)
                    self.errMsg = nil
                    self.postData.accept([result])
                }
                
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
//            case .noContent:
//                self.todos = []
            default: break
            }
        }
    }
}
