//
//  PostDetailView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/09.
//

import Foundation
import UIKit
import RxSwift
import SkeletonView
class PostDetailView : UIViewController, PostViewProtocol, DetailViewProtocol {
    
    var id : Int?
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var postContent: UILabel!
    
    @IBOutlet weak var postCreateDate: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    let bag = DisposeBag()
//    let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    var postDetailData : PostData = PostData(id: 0, title: "", content: "", is_published: true, created_at: "0000-00-00")
    
    var postVM : PostViewModel = PostViewModel.shared {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(postVM)")
        }
    }
    
    override func viewDidLoad() {
        initDetailView()
        bindViewModel(PostViewModel.shared)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.hideSkeleton()
        }
        
    }
    
    func initDetailView() {
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
    }
    
    //Protocol Function
    @objc func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindViewModel(_ viewModel: PostViewModel?) {
    
        self.view.showSkeleton()
        
        guard let viewModel = viewModel else {
            print("\(viewModel) is not Founded")
            return
        }
        
        viewModel.postDetailData.subscribe { data in
            if let data = data.element {
                data.images?.forEach({ image in
                    self.postImage.kf.setImage(with: URL(string: image.url))
                })
                self.postTitle.text = data.title
                self.postContent.text = data.content
                self.postCreateDate.text = data.created_at
                self.userName.text = "\(data.user_id)"
            }
        }.disposed(by: bag)
    }
}
