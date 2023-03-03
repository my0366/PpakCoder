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
    
    @IBOutlet weak var contentView: UIView!
    let bag = DisposeBag()
    let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    var postDetailData : PostData = PostData(id: 0, title: "", content: "", images: [], is_published: true, user_id: 0, created_at: "", updated_at: "")
    
    var viewModel : PostDetailViewModel = PostDetailViewModel() {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(viewModel)")
        }
    }
    override func viewDidLoad() {
        postTitle.isSkeletonable = true
        contentView.showSkeleton()
        bindViewModel(viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.initDetailView()
            self.view.hideSkeleton()
        }
    }

    func initDetailView() {
        
        postTitle.text = "\(postDetailData.title)"
        postContent.text = postDetailData.content
        postCreateDate.text = postDetailData.created_at
        postDetailData.images?.forEach({ image in
            postImage.kf.setImage(with: URL(string: image.url))
            
        })
        
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    
    //Protocol Function
    @objc func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindViewModel(_ viewModel: PostDetailViewModel?) {
    
        guard let viewModel = viewModel else {
            print("\(viewModel) is not Founded")
            return
        }
        if let id = id {
            viewModel.getPostDetail(id: id)
            print("Before = \(viewModel.postDetailData.value)")
        }
        
        viewModel.postDetailData.bind(to: self.rx.postDetailData).disposed(by: bag)
    
    }
}
