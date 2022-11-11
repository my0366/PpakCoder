//
//  PostUploadView.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/07.
//

import Foundation
import UIKit
import RxSwift
import Kingfisher

class PostUploadView : UIViewController, PostViewProtocol, DetailViewProtocol {
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var uploadImg: UIImageView!
    @IBOutlet weak var uploadTitle: UITextField!
    @IBOutlet weak var uploadContent: UITextField!
    
    let bag = DisposeBag()
    
    let imagePickerController = UIImagePickerController()
    let alertController  = UIAlertController()
    
    var postVM : PostViewModel = PostViewModel.shared {
        didSet {
            print(#fileID, #function, #line, "- viewModel: \(postVM)")
        }
    }
    
    func bindViewModel(_ viewModel: PostViewModel?){
        guard let viewModel = viewModel else {
            print("뷰모델 없어요")
            return
        }
    }
    override func viewDidLoad() {
        self.imagePickerController.delegate = self
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        bindViewModel(postVM)
        addGestureRecognizer()
        enrollAlertEvent()
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        
        guard let title = uploadTitle.text, let content = uploadContent.text, let image = uploadImg.image?.jpegData(compressionQuality: 1) else {
            return
        }
        
        let uploadData = Upload(title: title, content: content, published: true, image: [image])
        postVM.uploadPost(uploadData: uploadData)
            
        
    }
}

extension PostUploadView : UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let popoverPresentationController =
            self.alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect
            = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
    
    func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedUIImageView(_:)))
        self.uploadImg.addGestureRecognizer(tapGestureRecognizer)
        self.uploadImg.isUserInteractionEnabled = true
    }
    
    @objc func tappedUIImageView(_ gesture: UITapGestureRecognizer) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func enrollAlertEvent() {
        let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
            (action) in
            self.openAlbum()
        }
        let cameraAlertAction = UIAlertAction(title: "카메라", style: .default) {(action) in
            self.openCamera()
        }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlertAction)
        self.alertController.addAction(cameraAlertAction)
        self.alertController.addAction(cancelAlertAction)
        guard let alertControllerPopoverPresentationController = alertController.popoverPresentationController else {
            return
        }
        prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
    
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true // 수정 가능 여부
        
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.imagePickerController.sourceType = .camera
            present(self.imagePickerController, animated: false, completion: nil)
        }
        else {
            print ("Camera's not available as for now.")
        }
    }
}

extension PostUploadView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.uploadImg.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
        if let Byte = uploadImg.image {
            print(Byte.jpegData(compressionQuality: 1) as Any)
        }
    }
}
