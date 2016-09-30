//
//  SACollectionViewVerticalScalingCell.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/06/07.
//
//

import UIKit

open class SACollectionViewVerticalScalingCell : UICollectionViewCell {
    
    open var shadeTransform: CGAffineTransform = .identity {
        didSet {
            shadeView?.transform = shadeTransform
        }
    }
    open var shadeAlpha: CGFloat = 0 {
        didSet {
            shadeView?.alpha = shadeAlpha
        }
    }
    
    open fileprivate(set) var containerView: UIView?
    fileprivate var shadeView: UIView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        configuration()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
}

//MARK: - Private Methods
extension SACollectionViewVerticalScalingCell {
    fileprivate func configuration() {
        backgroundColor = .clear
        
        let containerView = UIView(frame: bounds)
        addSubview(containerView)
        self.containerView = containerView
        
        let shadeView = UIView(frame: bounds)
        shadeView.backgroundColor = .black
        addSubview(shadeView)
        self.shadeView = shadeView
        shadeAlpha = 0
    }
}

//MARK: - Override Methods
extension SACollectionViewVerticalScalingCell {
    open override func prepareForReuse() {
        super.prepareForReuse()
        containerView?.removeFromSuperview()
        containerView = nil
        shadeView?.removeFromSuperview()
        shadeView = nil
        configuration()
    }
}
