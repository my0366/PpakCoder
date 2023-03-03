//
//  LoadingView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/12/02.
//

import Foundation
import UIKit

class LoadingView : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- <#comment#>")
        
        setupLayout()
    }

    fileprivate func setupLayout(){
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        
        let loadingIndicator : UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
//            indicator.tintColor = .white
            indicator.color = .white
            indicator.startAnimating()
            return indicator
        }()
        
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
    }
    
}



// UIApplication 익스텐션
extension UIApplication {
    
    func topViewController() -> UIViewController? {
       // 애플리케이션 에서 키윈도우로 제일 아래 뷰컨트롤러를 찾고
       // 해당 뷰컨트롤러를 기점으로 최상단의 뷰컨트롤러를 찾아서 반환
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        return  windowScenes?.windows
                  .filter { $0.isKeyWindow }
                  .first?.rootViewController?
                  .topViewController()
    }
}

// UIViewController 익스텐션
extension UIViewController {
    func topViewController() -> UIViewController {
        // 프리젠트 방식의 뷰컨트롤러가 있다면
        if let presented = self.presentedViewController {
            // 해당 뷰컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
            return presented.topViewController()
        }
        // 자기 자신이 네비게이션 컨트롤러 라면
        if let navigation = self as? UINavigationController {
            // 네비게이션 컨트롤러에서 보이는 컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
            return navigation.visibleViewController?.topViewController() ?? navigation
        }
        // 최상단이 탭바 컨트롤러 라면
        if let tab = self as? UITabBarController {
            // 선택된 뷰컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
            return tab.selectedViewController?.topViewController() ?? tab
        }
        // 재귀를 타다가 최상단 뷰컨트롤러를 반환
        return self
    }
}

// UIDevice 익스텐션으로 만들어줍니다.
extension UIDevice {
    var hasNotch: Bool {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows
        
        let bottom = window?.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        
        return bottom > 0
    }
}

