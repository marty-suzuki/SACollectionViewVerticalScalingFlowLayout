//
//  ViewController.swift
//  SACollectionViewVerticalScalingFlowLayoutExample
//
//  Created by 鈴木大貴 on 2015/06/07.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit
import SACollectionViewVerticalScalingFlowLayout

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let kCellIdentifier = "Cell"
    private var scrolling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.registerClass(SACollectionViewVerticalScalingCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        
        guard let layout = collectionView.collectionViewLayout as? SACollectionViewVerticalScalingFlowLayout else {
            return
        }
        
        layout.scaleMode = .Hard
        layout.alphaMode = .Easy
        switch collectionView.tag {
            case 10001:
                layout.scrollDirection = .Vertical
                
            case 10002:
                layout.scrollDirection = .Vertical
                layout.itemSize = CGSize(width: 100, height: 100)
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
                
            case 10003:
                layout.scrollDirection = .Horizontal
                
            default:
                layout.scrollDirection = .Horizontal
                layout.itemSize = CGSize(width: 100, height: 100)
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let tagNumber = 10001
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath)
        
        if let cell = cell as? SACollectionViewVerticalScalingCell {
            cell.containerView?.viewWithTag(tagNumber)?.removeFromSuperview()
            
            let imageView = UIImageView(frame: cell.bounds)
            imageView.tag = tagNumber
            let number = indexPath.row % 7 + 1
            imageView.image = UIImage(named: "0\(number)")
            cell.containerView?.addSubview(imageView)
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrolling = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrolling = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            if !self.scrolling {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        })
    }
}