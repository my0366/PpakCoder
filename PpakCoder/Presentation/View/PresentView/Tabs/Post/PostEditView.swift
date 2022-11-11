//
//  PostEditView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/08.
//

import Foundation
import RxSwift
import UIKit

class PostEditView : UIViewController, DetailViewProtocol {
    
    func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }

}
