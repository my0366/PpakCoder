//
//  PostViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

@MainActor
class PostViewModel {
    
    static let postDetailNotificationName = "postDetailNotification"
    
    static let shared = PostViewModel()
    
    let disposeBag = DisposeBag()
    
    var loadingVC : LoadingView? = nil
    
    init() {
        print(#fileID, #function, #line, "- ")
        initFetchPostViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPostDetail(_:)), name: Notification.Name(rawValue: PostViewModel.postDetailNotificationName), object: nil)
        
        isLoading.subscribe { [weak self] value in
            guard let self = self else { return }
            if let isLoading = value.element {
                
                print("loading value = \(isLoading)")
                if isLoading {
//                    self.loadingVC = self.showLoadingPopup()
                } else {
//                    self.stopLoadingPopup(loadingVC: self.loadingVC)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PostViewModel.postDetailNotificationName), object: nil)
    }
    
    @objc fileprivate func getPostDetail(_ notification: NSNotification) {
        getPostDetail(id : notification.object as! Int) { res in
            
        }
    }
    
    var alertEvent = PublishSubject<MsgType>()
    
    var postData = BehaviorRelay<[PostData]>(value: [])
    
    var postDetailData = BehaviorRelay<PostData>(value: PostData(id: 0, title: "", content: "", images: [], is_published: true, user_id: 0, created_at: "", updated_at: ""))
    
    
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
            self.postDetailData.accept(data)
            self.isLoading.accept(false)
        }
    }
    
    func initFetchPostViewModel() {
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
    
    func getPostDetail(id : Int, completion : @escaping (Bool) -> Void) {
        
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

extension PostViewModel {
    
    /// 로딩 팝업 띄우기
    /// - Returns: 로딩 팝업
    func showLoadingPopup() -> LoadingView?{
        print(#fileID, #function, #line, "- <#comment#>")
        
        let parentVC = UIApplication.shared.topViewController()
        
        if parentVC is LoadingView {
            return nil
        }
        
        print("parent = \(parentVC)")
        let loadingPopupVC = LoadingView()
        
        // 뷰컨트롤러가 보여지는 스타일
        loadingPopupVC.modalPresentationStyle = .overFullScreen
        
        // 뷰컨트롤러가 사라지는 스타일
        loadingPopupVC.modalTransitionStyle = .crossDissolve
        
        parentVC?.present(loadingPopupVC, animated: true, completion: nil)
        
        return loadingPopupVC
    }
    
    /// 로딩 팝업 띄우기
    /// - Returns: 로딩 팝업
    func stopLoadingPopup(loadingVC : LoadingView?){
        print(#fileID, #function, #line, "- <#comment#>")

        loadingVC?.dismiss(animated: true)
    }
}
