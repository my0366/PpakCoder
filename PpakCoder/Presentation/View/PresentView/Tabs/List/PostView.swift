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

protocol ViewModelProvider {
    var viewModel: PostViewModel { get }
}

class PostView : UIViewController, ViewModelProvider {
    
    var viewModel = PostViewModel()


    @IBOutlet weak var postCollectionView: UICollectionView!
        
    fileprivate func onLoad() {
        PostViewModel().getAllPosts(page: 1, order_by: "desc", per_page: 10, status: "all")
    }
    
    let bag = DisposeBag()
    var postData : [PostData] = []
    override func viewDidLoad() {
        onLoad()
        
    }
    
}

//extension PostView : UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCell else {
//            return UICollectionViewCell()
//        }
//        cell.postName.text = "aa"
//
//        return cell
//    }
//
//
//}

//extension PostView: SkeletonCollectionViewDataSource {
//    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return PostViewModel.shared.postData.count
//    }
//
//    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return PostViewModel.shared.postData.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
//        let post = PostViewModel.shared.postData[indexPath.row]
//
//        //        cell.postImage.kf.setImage(with: URL(string: post.images[0].url ?? ""))
//        cell.postName.text = post.title
//        //        cell.postPublisheer.text = "\(post.user_id)"
//        return cell
//    }
//    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "PostCell"
//    }
//}
