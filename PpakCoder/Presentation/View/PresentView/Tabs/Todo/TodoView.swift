//
//  TodoView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/11.
//

import Foundation
import RxSwift
import UIKit
import SkeletonView

class TodoView : UIViewController {
    
    let bag = DisposeBag()
    var todoData : [TodoData] = []
    
    var todoVM : TodoViewModel? = TodoViewModel() {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(todoVM)")
        }
    }
    override func viewDidLoad() {
        bindViewModel(todoVM)
        
        todoVM?.todoData.bind(to: self.rx.todoData).disposed(by: bag)
        
        print(todoData)
    }
    
    func bindViewModel(_ viewModel: TodoViewModel?){
        guard let viewModel = viewModel else {
            print("뷰모델 없어요")
            return
        }
    }
}
