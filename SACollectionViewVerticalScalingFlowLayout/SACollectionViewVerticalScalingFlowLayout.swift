//
//  SACollectionViewVerticalScalingFlowLayout.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/06/07.
//
//

import UIKit

private let kEasyValue: CGFloat = 0.05
private let kHardValue: CGFloat = 0.2

public enum SACollectionViewVerticalScalingFlowLayoutAlphaMode {
    case None, Easy, Hard
    
    func value() -> CGFloat {
        switch self {
            case .None:
                return 0
                
            case .Easy:
                return kEasyValue
                
            case .Hard:
                return kHardValue
        }
    }
}

public enum SACollectionViewVerticalScalingFlowLayoutScaleMode {
    case None, Easy, Hard
    
    func value() -> CGFloat {
        switch self {
            case .None:
                return 0
                
            case .Easy:
                return kEasyValue
                
            case .Hard:
                return kHardValue
        }
    }
}

//MARK: - Initialize Methods
public class SACollectionViewVerticalScalingFlowLayout : UICollectionViewFlowLayout {
    
    public var scaleMode: SACollectionViewVerticalScalingFlowLayoutAlphaMode = .Easy
    public var alphaMode: SACollectionViewVerticalScalingFlowLayoutScaleMode = .Easy
    
    private var dynamicAnimator: UIDynamicAnimator?
    
    private let kMinimumInteritemSpacing: CGFloat = 25
    private let kMinimumLineSpacing: CGFloat = 25
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    public override init() {
        super.init()
        configuration()
    }
}

//MARK: - Private Methods
extension SACollectionViewVerticalScalingFlowLayout {
    private func configuration() {
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        minimumInteritemSpacing = kMinimumInteritemSpacing
        minimumLineSpacing = kMinimumLineSpacing
        let width = UIScreen.mainScreen().bounds.size.width
        itemSize = CGSize(width: width - kMinimumInteritemSpacing * 2, height: width - kMinimumLineSpacing * 2)
        sectionInset = UIEdgeInsets(top: kMinimumLineSpacing, left: kMinimumInteritemSpacing, bottom: kMinimumLineSpacing, right: kMinimumInteritemSpacing)
    }
    
    private func scalingProcess(cell: SACollectionViewVerticalScalingCell, var scale: CGFloat, var alpha: CGFloat, minimuScale: CGFloat, minimumAlpha: CGFloat) {
        if scaleMode != .None {
            if scale > 1 {
                scale = 1
            } else if scale < minimuScale {
                scale = minimuScale
            }
            let transform = CGAffineTransformMakeScale(scale, scale)
            cell.containerView?.transform = transform
            cell.shadeTransform = transform
        }
        
        if alphaMode != .None {
            if alpha > 1 {
                alpha = 1
            } else if alpha < minimumAlpha {
                alpha = minimumAlpha
            }
            cell.shadeAlpha = (1 - alpha) * 10
        }
    }
}

//MARK: - Override Methods
extension SACollectionViewVerticalScalingFlowLayout {
    override public func prepareLayout() {
        super.prepareLayout()
        
        if let contentSize = collectionView?.contentSize, dynamicAnimator = dynamicAnimator, items = super.layoutAttributesForElementsInRect(CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)) {
            if dynamicAnimator.behaviors.count < 1 {
                for (index, item) in items.enumerate() {
                    let behaviour = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                    behaviour.length = 0
                    behaviour.damping = 0.8
                    behaviour.frequency = 1
                    dynamicAnimator.addBehavior(behaviour)
                }
            }
        }
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let items = dynamicAnimator?.itemsInRect(rect), cells = collectionView?.visibleCells() as? [SACollectionViewVerticalScalingCell], toView = collectionView?.superview, collectionViewSize = collectionView?.bounds.size {

            switch scrollDirection {
            case .Vertical:
                for cell in cells {
                    if let point = cell.superview?.convertPoint(cell.frame.origin, toView: toView) {
                        let cellSize = cell.bounds.size
                        if -cellSize.height / 2 >= point.y {
                            let baseValue = 1 - (point.y / (-cellSize.height / 2))
                            let scale = 1 + baseValue * scaleMode.value()
                            let alpha = 1 + baseValue * 0.1
                            scalingProcess(cell, scale: scale, alpha: alpha, minimuScale: scaleMode.value(), minimumAlpha: alphaMode.value())
                        } else if collectionViewSize.height - ((cellSize.height / 4) * 3) <= point.y {
                            let baseValue = (point.y - (collectionViewSize.height - ((cellSize.height / 4) * 3))) / ((cellSize.height / 4) * 3)
                            let scale = 1 - baseValue * scaleMode.value()
                            let alpha = 1 - baseValue * 0.1
                            scalingProcess(cell, scale: scale, alpha: alpha, minimuScale: scaleMode.value(), minimumAlpha: alphaMode.value())
                        }
                    }
                }

            case .Horizontal:
                for cell in cells {
                    if let point = cell.superview?.convertPoint(cell.frame.origin, toView: toView) {
                        let cellSize = cell.bounds.size
                        if -cellSize.width / 2 >= point.x {
                            let baseValue = 1 - (point.x / (-cellSize.width / 2))
                            let scale = 1 + baseValue * scaleMode.value()
                            let alpha = 1 + baseValue * 0.1
                            scalingProcess(cell, scale: scale, alpha: alpha, minimuScale: scaleMode.value(), minimumAlpha: alphaMode.value())
                        } else if collectionViewSize.width - ((cellSize.width / 4) * 3) <= point.x {
                            let baseValue = (point.x - (collectionViewSize.width - ((cellSize.width / 4) * 3))) / ((cellSize.width / 4) * 3)
                            let scale = 1 - baseValue * scaleMode.value()
                            let alpha = 1 - baseValue * 0.1
                            scalingProcess(cell, scale: scale, alpha: alpha, minimuScale: scaleMode.value(), minimumAlpha: alphaMode.value())
                        }
                    }
                }
            }
            if !items.isEmpty {
              return items as? [UICollectionViewLayoutAttributes]
          }
        }
        return super.layoutAttributesForElementsInRect(rect)
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        if let attributes = dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath) {
            return attributes
        }
        return super.layoutAttributesForItemAtIndexPath(indexPath)
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        /***
        This method is based on this sample.
        http://www.objc.io/issue-5/collection-views-and-uidynamics.html
        ***/
        
        if let collectionView = collectionView, behaviors = dynamicAnimator?.behaviors as? [UIAttachmentBehavior] {
            switch scrollDirection {
                case .Vertical:
                    let delta = newBounds.origin.y - collectionView.bounds.origin.y
                    let touchPoint = collectionView.panGestureRecognizer.locationInView(collectionView)
                    for (index, behavior) in behaviors.enumerate() {
                        let yDistanceFromTouch = fabs(touchPoint.y - behavior.anchorPoint.y)
                        let xDistanceFromTouch = fabs(touchPoint.x - behavior.anchorPoint.x)
                        let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500
                        
                        if let attributes = behavior.items.first as? UICollectionViewLayoutAttributes {
                            var center = attributes.center
                            if delta < 0 {
                                center.y += max(delta, delta * scrollResistance)
                            } else {
                                center.y += min(delta, delta * scrollResistance)
                            }
                            attributes.center = center
                            
                            dynamicAnimator?.updateItemUsingCurrentState(attributes)
                        }
                    }
                
                case .Horizontal:
                    let delta = newBounds.origin.x - collectionView.bounds.origin.x
                    let touchPoint = collectionView.panGestureRecognizer.locationInView(collectionView)
                    for (index, behavior) in behaviors.enumerate() {
                        let yDistanceFromTouch = fabs(touchPoint.y - behavior.anchorPoint.y)
                        let xDistanceFromTouch = fabs(touchPoint.x - behavior.anchorPoint.x)
                        let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500
                        
                        if let attributes = behavior.items.first as? UICollectionViewLayoutAttributes {
                            var center = attributes.center
                            if delta < 0 {
                                center.x += max(delta, delta * scrollResistance)
                            } else {
                                center.x += min(delta, delta * scrollResistance)
                            }
                            attributes.center = center
                            
                            dynamicAnimator?.updateItemUsingCurrentState(attributes)
                        }
                    }
            }
            
            return true
        }
        
        return false
    }
}