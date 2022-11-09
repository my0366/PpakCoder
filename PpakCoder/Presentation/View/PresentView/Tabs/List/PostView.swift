//
//  PostView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView
import RxSwift



class PostView : UIViewController {
    
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    var postVM : PostViewModel? = PostViewModel() {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(postVM)")
        }
    }
     
    
    let bag = DisposeBag()
    var postData : [PostData] = []
    override func viewDidLoad() {
        bindViewModel(postVM)
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.showSkeleton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.view.hideSkeleton() // Hide Skeleton
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func bindViewModel(_ viewModel: PostViewModel?){
        
        guard let viewModel = viewModel else {
            print("뷰모델 없어요")
            return
        }
        viewModel.postData.bind(to: self.rx.postData).disposed(by: DisposeBag())
    }
}

extension PostView: SkeletonCollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = postData[indexPath.row]
        
        cell.postImage.kf.setImage(with: URL(string: "https://res.cloudinary.com/ppak-coders-com/image/upload/v1666806231/hqsyofpx1s3jtao0gjuj.png"))
        cell.postName.text = post.title
    
        cell.postPublisheer.text = "\(post.user_id)"
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PostCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 10
        let textAreaHeight : CGFloat = 65
        let width : CGFloat = (collectionView.bounds.width - itemSpacing) / 2
        let height : CGFloat = width * 10 / 8 + textAreaHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = postData[indexPath.row].id
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: PostViewModel.postDetailNotificationName), object: id)
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailView") else {
            return
        }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

