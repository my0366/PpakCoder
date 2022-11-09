//
//  GetAllPostsUseCaseProtocol.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/08.
//

import Foundation

protocol GetAllPostsUseCaseProtocol {
    func getAllPosts(page : Int, order_by : String, per_page : Int, status : String, completion : @escaping (Post) -> Void)
}
