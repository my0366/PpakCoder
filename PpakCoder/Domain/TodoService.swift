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
    
    static func getAllTodoData(page : Int, order_by : String, per_page : Int) -> Observable<Todo> {
        return Observable.create { observer in
            Client.request(Todo.self, router: TodoRouter.getAllTodo(page: page, order_by: order_by, per_page: per_page)) { decodeData in
                observer.onNext(decodeData)
            } failure: { error in
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
    
    static func endAddTodo(title : String) -> Observable<Todo> {
        self.addTodo(title: title, done: true).flatMapLatest { _ in
                return self.getAllTodoData(page: 1, order_by: "desc", per_page: 10)
            }
        .share(replay: 1)
    }
    
    static func addTodo(title : String, done : Bool) -> Observable<TodoResponse> {
        return Observable.create { observer in
            Client.request(TodoResponse.self, router: TodoRouter.uploadTodo(title: title, is_done: done)) { response in
                print("res = \(response)")
                observer.onNext(response)
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
