//
//  TodoService.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/11.
//

import Foundation
import Alamofire
import RxSwift

class TodoService {
    
    
    static let shared = TodoService()
    
    func getAllTodoData(page : Int, order_by : String, per_page : Int) -> Observable<Todo> {
        return Observable.create { observer in
            Client.request(Todo.self, router: TodoRouter.getAllTodo(page: page, order_by: order_by, per_page: per_page)) { decodeData in
                observer.onNext(decodeData)
            } failure: { error in
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}
