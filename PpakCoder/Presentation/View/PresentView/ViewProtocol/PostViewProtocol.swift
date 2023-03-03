//
//  PostViewProtocol.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/10.
//

import Foundation
import RxSwift

protocol PostViewProtocol {
    
//    var postVM : PostViewModel? { get set }
    
//    func bindViewModel(_ viewModel: PostViewModel?)
    
    var bag : DisposeBag { get } 
}
