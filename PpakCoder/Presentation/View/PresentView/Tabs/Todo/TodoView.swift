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
    @IBOutlet weak var todoTableView: UITableView!
    
    
    
    var todoVM  = TodoViewModel() {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(todoVM)")
        }
    }
    override func viewDidLoad() {
        bindViewModel(todoVM)
        todoTableView.dataSource = self
    }
    
    func bindViewModel(_ viewModel: TodoViewModel?){
        guard let viewModel = viewModel else {
            print("뷰모델 없어요")
            return
        }
        todoVM.todoData.bind(to: self.rx.todoData).disposed(by: bag)
    }

    @IBAction func addTodoButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "추가할 할 일을 입력해주세요", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let failedAlert = UIAlertController(title: "알림", message: todoVM.alertMessage, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "확인", style: .default))
        
        let submitAction = UIAlertAction(title: "확인", style: .default) { [unowned ac] _ in
            
            let input = ac.textFields![0]

            // do something interesting with "answer" here
            print("할일 추가 클릭 : \(input.text)")
            
            guard let inputText = input.text else {
                return
            }
            
            self.todoVM.addTodo(title: inputText, done: false)
            self.present(failedAlert, animated: true)
            self.todoVM.initFetch()
            self.todoTableView.reloadData()
            
        }
        
        let deleteAction = UIAlertAction(title: "닫기", style: .destructive) { [unowned ac] _ in
            print("취소 클릭")
        }

        ac.addAction(deleteAction)
        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
}

extension TodoView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.todoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let todo = todoData[indexPath.row]
        cell.todoTitle.text = todo.title
        
        cell.todoSwitch.isOn = todo.is_done
        
        return cell
    }
}

