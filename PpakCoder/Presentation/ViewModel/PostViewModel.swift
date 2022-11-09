//
//  PostViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import RxSwift

class PostViewModel {
        
    var posts : [PostData] = []
    
    var postUseCase = GetAllPostsUseCase()
    
    init(posts: [PostData]) {
        self.posts = posts
    }
    func getAllPosts(page : Int, order_by : String, per_page : Int, status : String) {
        postUseCase.getAllPosts(page: page, order_by: order_by, per_page: per_page, status: status, completion: { data in
//            print(data)
        })
    }
}
