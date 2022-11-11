//
//  UserViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/03.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
class UserViewModel {
    
    static let shared = UserViewModel()
    
    final func login(email : String, password : String, completion : @escaping (String) -> Void) {
        Client.request(LoginData.self, router: PostRouter.login(email: email, password: password)) { result in
            if let resultData = result.data {
                KeychainWrapper.standard.set("Bearer \(resultData.token.access_token)", forKey: "access-token")
            }
            completion(result.message)
            
        } failure: { error in
            completion("로그인에 오류가 발생했습니다")
        }
    }
    
    final func register(name : String
                        , email : String
                        , password : String
                        , completion : @escaping (String) -> Void) {
        Client.request(LoginData.self, router: PostRouter.register(name: name, email: email, password: password)) { result in
            completion(result.message)
        } failure: { error in
            completion("회원가입에 오류가 발생했습니다.")
        }
    }
}

