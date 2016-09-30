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
    
    fileprivate let kCellIdentifier = "Cell"
    fileprivate var scrolling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.register(SACollectionViewVerticalScalingCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        
        guard let layout = collectionView.collectionViewLayout as? SACollectionViewVerticalScalingFlowLayout else {
            return
        }
        
        layout.scaleMode = .hard
        layout.alphaMode = .easy
        switch collectionView.tag {
            case 10001:
                layout.scrollDirection = .vertical
                
            case 10002:
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: 100, height: 100)
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
                
            case 10003:
                layout.scrollDirection = .horizontal
                
            default:
                layout.scrollDirection = .horizontal
                layout.itemSize = CGSize(width: 100, height: 100)
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tagNumber = 10001
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
        
        if let cell = cell as? SACollectionViewVerticalScalingCell {
            cell.containerView?.viewWithTag(tagNumber)?.removeFromSuperview()
            
            let imageView = UIImageView(frame: cell.bounds)
            imageView.tag = tagNumber
            let number = (indexPath as NSIndexPath).row % 7 + 1
            imageView.image = UIImage(named: "0\(number)")
            cell.containerView?.addSubview(imageView)
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrolling = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrolling = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            if !self.scrolling {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        })
    }
}
