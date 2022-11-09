//
//  PostRepository.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/08.
//

import Foundation
import RxSwift


class PostRepository : PostRepositoryProtocol  {
    
    var postData : [Post] = []
    let repository : PostRepository?
    
    init(repository : PostRepository? = nil) {
        self.repository = repository
    }
    
    func save(data : Post?) {
        if let data = data {
            postData.append(data)
            print("postData = \(postData)")
        } else {
            print("save failed")
        }
        
    }

}

