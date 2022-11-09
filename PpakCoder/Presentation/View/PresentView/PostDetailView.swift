//
//  PostDetailView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/09.
//

import Foundation
import UIKit

class PostDetailView : UIViewController {
    
    var postVM : PostViewModel? = PostViewModel() {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(postVM)")
        }
    }
    
    override func viewDidLoad() {
        print("a")
//        bindViewModel(PostViewModel())
    }
}
