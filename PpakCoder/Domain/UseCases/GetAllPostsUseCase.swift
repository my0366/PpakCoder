//
//  MockGetAllPosts.swift
//  
//
//  Created by 성제 on 2022/11/08.
//
import Foundation

final class GetAllPostsUseCase: GetAllPostsUseCaseProtocol {
    
    func getAllPosts(page: Int, order_by: String, per_page: Int, status: String, completion: @escaping (Post) -> Void) {
        Client.request(Post.self, router: Router.getAllPost(page: page, order_by: order_by, per_page: per_page, status: status)) { result in
            PostRepository().save(data: result)
        } failure: { error in
            print("fail")
        }
    }
}
