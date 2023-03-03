//
//  TodoViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/11.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

@MainActor
class TodoViewModel {
    
    let disposeBag = DisposeBag()
    
    var loadingVC : LoadingView? = nil
    init() {
        initFetch()
        
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
    
    let todoData : BehaviorRelay<[TodoData]> = BehaviorRelay<[TodoData]>(value: [])
    @Published var errMsg : String? = nil
    
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value : false)
    
    var alertEvent = PublishSubject<MsgType>()
    
    var alertMessage : String = ""
    
    fileprivate func submitData(data: [TodoData]){
        DispatchQueue.main.async {
            self.errMsg = nil
            self.todoData.accept(data)
            self.isLoading.accept(false)
        }
    }
    
    fileprivate func submitTodoData(data: [TodoData]){
        DispatchQueue.main.async {
            self.errMsg = nil
            self.todoData.accept(data)
            print("data = \(data)")
            self.isLoading.accept(false)
        }
    }
    
    func resetData(){
        DispatchQueue.main.async {
            self.todoData.accept([])
            self.isLoading.accept(false)
        }
    }
    
    func initFetch() {
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        TodoService.getAllTodoData(page: 1, order_by: "desc", per_page: 10)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                      let data = result.data else {
                    return
                }
                self.submitData(data: data)
            }, onError: { [weak self] err in
                guard let self = self,
                      let apiError = err as? ApiError else {
                    return
                }
                self.handleError(apiError)
            })
            .disposed(by: disposeBag)
    }
    
    func addTodo(title : String, done : Bool) {
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        TodoService.endAddTodo(title: title)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self ,
                let data = result.data else {
                    return
                }
                self.resetData()
                self.alertMessage = result.message
                self.submitTodoData(data: data)
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


//extension TodoViewModel {
//
//    /// 로딩 팝업 띄우기
//    /// - Returns: 로딩 팝업
//    func showLoadingPopup() -> LoadingView?{
//        print(#fileID, #function, #line, "- <#comment#>")
//
//        let parentVC = UIApplication.shared.topViewController()
//
//        if parentVC is LoadingView {
//            return nil
//        } else if parentVC is PostView {
//            return nil
//        }
//
//        let loadingPopupVC = LoadingView()
//
//        // 뷰컨트롤러가 보여지는 스타일
//        loadingPopupVC.modalPresentationStyle = .overFullScreen
//
//        // 뷰컨트롤러가 사라지는 스타일
//        loadingPopupVC.modalTransitionStyle = .crossDissolve
//
//        parentVC?.present(loadingPopupVC, animated: true, completion: nil)
//
//        return loadingPopupVC
//    }
//
//    /// 로딩 팝업 띄우기
//    /// - Returns: 로딩 팝업
//    func stopLoadingPopup(loadingVC : LoadingView?){
//        print(#fileID, #function, #line, "- <#comment#>")
//
//        loadingVC?.dismiss(animated: true)
//    }
//}
