//
//  ViewController.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/03.
//

import UIKit
import FSPagerView
class BoardingView: UIViewController,FSPagerViewDelegate,FSPagerViewDataSource {
    
    fileprivate let onBoardingImage = ["OnBoarding4.png", "OnBoarding7.png"]
    
    @IBOutlet weak var boardingLabel: UILabel!
    @IBOutlet weak var onBoardingView: FSPagerView! {
        didSet {
            self.onBoardingView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            
            self.onBoardingView.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var onBoardingPageControl: FSPageControl! {
        didSet {
            self.onBoardingPageControl.numberOfPages = onBoardingImage.count
            self.onBoardingPageControl.itemSpacing = 5
            self.onBoardingPageControl.contentHorizontalAlignment = .center
            self.onBoardingPageControl.interitemSpacing = 5
            self.onBoardingPageControl.setStrokeColor(.gray, for: .normal)
            self.onBoardingPageControl.setStrokeColor(.red, for: .selected)
            self.onBoardingPageControl.setFillColor(.red, for: .selected)
            self.onBoardingPageControl.setFillColor(.gray, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onBoardingView.dataSource = self
        self.onBoardingView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        if self.onBoardingPageControl.currentPage == 0 {
            
        } else {
            self.onBoardingPageControl.currentPage = self.onBoardingPageControl.currentPage - 1
        }
        
        
        self.onBoardingView.scrollToItem(at: self.onBoardingPageControl.currentPage, animated: true)
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        if self.onBoardingPageControl.currentPage == 1 {
            
        } else {
            self.onBoardingPageControl.currentPage = self.onBoardingPageControl.currentPage + 1
        }
        
        self.onBoardingView.scrollToItem(at: self.onBoardingPageControl.currentPage, animated: true)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return onBoardingImage.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.imageView?.image = UIImage(named: onBoardingImage[index])
        
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.onBoardingPageControl.currentPage = targetIndex
        
        if self.onBoardingPageControl.currentPage == 1{
            self.boardingLabel.text = "오늘도 빡코딩!"
            
        }
    }
}

