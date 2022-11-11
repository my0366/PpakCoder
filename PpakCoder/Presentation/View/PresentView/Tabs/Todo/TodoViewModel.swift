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
    
    init() {
        initFetch()
    }
    
    let todoData : BehaviorRelay<[TodoData]> = BehaviorRelay<[TodoData]>(value: [])
    @Published var errMsg : String? = nil
    
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value : false)
    
    var alertEvent = PublishSubject<MsgType>()
    
    fileprivate func submitData(data: [TodoData]){
        
        DispatchQueue.main.async {
            self.errMsg = nil
            self.todoData.accept(data)
            self.isLoading.accept(false)
        }
    }
    
    func initFetch() {
        
        DispatchQueue.main.async {
            self.isLoading.accept(true)
        }
        
        TodoService.shared.getAllTodoData(page: 1, order_by: "desc", per_page: 10)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self,
                let data = result.data else {
                    return
                }
                
                print(data)
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
