//
//  UserViewModel.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/03.
//

import Foundation
import Alamofire

class UserViewModel {
    
    static let shared = UserViewModel()
    
    final func login(email : String, password : String, completion : @escaping (String) -> Void) {
        Client.request(LoginData.self, router: Router.login(email: email, password: password)) { data in
            completion(data.message)
        } failure: { error in
            completion("로그인에 오류가 발생했습니다")
        }
    }
    
    final func register(name : String
                        , email : String
                        , password : String
                        , completion : @escaping (String) -> Void) {
        Client.request(LoginData.self, router: Router.register(name: name, email: email, password: password)) { result in
            completion(result.message)
        } failure: { error in
            completion("회원가입에 오류가 발생했습니다.")
        }
    }
}

