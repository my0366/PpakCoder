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

class PostView : UIViewController, PostViewProtocol {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    
    var postVM : PostViewModel = PostViewModel() {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(postVM)")
        }
    }
     
    let bag = DisposeBag()
    var postData : [PostData] = []
    
    override func viewDidLoad() {
        print("init \(postVM.isLoading.value)")
        bindViewModel(postVM)
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.showSkeleton()
        
        if !postVM.isLoading.value {
            self.view.hideSkeleton()
        }
    }
    
    func bindViewModel(_ viewModel: PostViewModel?){
        guard let viewModel = viewModel else {
            print("뷰모델 없어요")
            return
        }
        viewModel.postData.bind(to: self.rx.postData).disposed(by: DisposeBag())
        
    }
    
    @IBAction func addPostButton(_ sender: Any) {
        guard let postUploadVC = self.storyboard?.instantiateViewController(withIdentifier: "PostUploadView") else {
            return
        }
        self.navigationController?.pushViewController(postUploadVC, animated: true)
        
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
       
        if let image = post.images {
            for i in image {
                cell.postImage.kf.setImage(with: URL(string: i.url))
            }
        } else {
            cell.postImage.image = UIImage.init(named: "NoImage")
        }
        
        cell.postName.text = post.title
    
        cell.postPublisheer.text = "\(post.id)"
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PostCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 10
        let textAreaHeight : CGFloat = 65
        let width : CGFloat = (collectionView.bounds.width - itemSpacing) / 2.3
        let height : CGFloat = width * 10 / 8 + textAreaHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = postData[indexPath.row].id
        
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailView") as? PostDetailView else {
            return
        }
        
        detailVC.id = id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

