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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.registerClass(SACollectionViewVerticalScalingCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        if let layout = collectionView.collectionViewLayout as? SACollectionViewVerticalScalingFlowLayout {
            layout.scaleMode = .Hard
            layout.alphaMode = .Easy
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! SACollectionViewVerticalScalingCell
        
        cell.containerView?.viewWithTag(tagNumber)?.removeFromSuperview()
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.tag = tagNumber
        let number = indexPath.row % 7 + 1
        imageView.image = UIImage(named: "0\(number)")
        cell.containerView?.addSubview(imageView)
        
        return cell
    }
}