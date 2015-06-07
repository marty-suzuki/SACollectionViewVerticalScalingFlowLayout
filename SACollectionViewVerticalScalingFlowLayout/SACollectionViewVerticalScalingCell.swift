//
//  SACollectionViewVerticalScalingCell.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/06/07.
//
//

import UIKit

public class SACollectionViewVerticalScalingCell : UICollectionViewCell {
    
    public var shadeTransform = CGAffineTransformIdentity {
        didSet {
            shadeView?.transform = shadeTransform
        }
    }
    public var shadeAlpha: CGFloat = 0 {
        didSet {
            shadeView?.alpha = shadeAlpha
        }
    }
    
    public private(set) var containerView: UIView?
    private var shadeView: UIView?
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    public init() {
        super.init(frame: CGRectZero)
        configuration()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
}

//MARK: - Private Methods
extension SACollectionViewVerticalScalingCell {
    private func configuration() {
        backgroundColor = .clearColor()
        
        let containerView = UIView(frame: bounds)
        addSubview(containerView)
        self.containerView = containerView
        
        let shadeView = UIView(frame: bounds)
        shadeView.backgroundColor = .blackColor()
        addSubview(shadeView)
        self.shadeView = shadeView
        shadeAlpha = 0
    }
}

//MARK: - Override Methods
extension SACollectionViewVerticalScalingCell {
    public override func prepareForReuse() {
        super.prepareForReuse()
        containerView?.removeFromSuperview()
        containerView = nil
        shadeView?.removeFromSuperview()
        shadeView = nil
        configuration()
    }
}