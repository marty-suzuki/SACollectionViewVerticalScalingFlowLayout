//
//  SACollectionViewVerticalScalingFlowLayout.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/06/07.
//
//

import UIKit

struct Const {
    static let EasyValue: CGFloat = 0.05
    static let HardValue: CGFloat = 0.2
}

public enum SACollectionViewVerticalScalingFlowLayoutAlphaMode {
    case None, Easy, Hard
    var value: CGFloat {
        switch self {
        case .None: return 0
        case .Easy: return Const.EasyValue
        case .Hard: return Const.HardValue
        }
    }
}

public enum SACollectionViewVerticalScalingFlowLayoutScaleMode {
    case None, Easy, Hard
    var value: CGFloat {
        switch self {
            case .None: return 0
            case .Easy: return Const.EasyValue
            case .Hard: return Const.HardValue
        }
    }
}

//MARK: - Initialize Methods
public class SACollectionViewVerticalScalingFlowLayout : UICollectionViewFlowLayout {
    
    private struct Const {
        static let MinimumInteritemSpacing: CGFloat = 25
        static let MinimumLineSpacing: CGFloat = 25
    }
    
    public var scaleMode: SACollectionViewVerticalScalingFlowLayoutAlphaMode = .Easy
    public var alphaMode: SACollectionViewVerticalScalingFlowLayoutScaleMode = .Easy
    
    private lazy var dynamicAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(collectionViewLayout: self)
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuration()
    }
    
    public override init() {
        super.init()
        configuration()
    }

    //MARK: - Private Methods
    private func configuration() {
        minimumInteritemSpacing = Const.MinimumInteritemSpacing
        minimumLineSpacing = Const.MinimumLineSpacing
        let width = UIScreen.mainScreen().bounds.size.width
        itemSize = CGSize(width: width - Const.MinimumInteritemSpacing * 2, height: width - Const.MinimumLineSpacing * 2)
        sectionInset = UIEdgeInsets(top: Const.MinimumLineSpacing, left: Const.MinimumInteritemSpacing, bottom: Const.MinimumLineSpacing, right: Const.MinimumInteritemSpacing)
    }
    
    private func scalingProcess(cell: SACollectionViewVerticalScalingCell, scale: CGFloat, alpha: CGFloat, minimuScale: CGFloat, minimumAlpha: CGFloat) {
        if scaleMode != .None {
            let scale = max(0, min(1, max(minimuScale, scale)))
            let transform = CGAffineTransformMakeScale(scale, scale)
            cell.containerView?.transform = transform
            cell.shadeTransform = transform
        }
        
        if alphaMode != .None {
            cell.shadeAlpha = (1 - max(0 ,min(1, max(minimumAlpha, alpha)))) * 10
        }
    }
}

//MARK: - Override Methods
extension SACollectionViewVerticalScalingFlowLayout {
    override public func prepareLayout() {
        super.prepareLayout()
        
        guard
            let contentSize = collectionView?.contentSize,
            let items = super.layoutAttributesForElementsInRect(CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        where dynamicAnimator.behaviors.count < 1
        else { return }
        
        items.forEach {
            let behaviour = UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center)
            behaviour.length = 0
            behaviour.damping = 0.8
            behaviour.frequency = 1
            dynamicAnimator.addBehavior(behaviour)
        }
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let cells = collectionView?.visibleCells() as? [SACollectionViewVerticalScalingCell],
            let toView = collectionView?.superview,
            let collectionViewSize = collectionView?.bounds.size
        else {
            return super.layoutAttributesForElementsInRect(rect)
        }
        
        let items = dynamicAnimator.itemsInRect(rect)
        switch scrollDirection {
            case .Vertical:
                cells.forEach {
                    guard let point = $0.superview?.convertPoint($0.frame.origin, toView: toView) else  { return }
                    let cellSize = $0.bounds.size
                    if -cellSize.height / 2 >= point.y {
                        let baseValue = 1 - (point.y / (-cellSize.height / 2))
                        let scale = 1 + baseValue * scaleMode.value
                        let alpha = 1 + baseValue * 0.1
                        scalingProcess($0, scale: scale, alpha: alpha, minimuScale: scaleMode.value, minimumAlpha: alphaMode.value)
                    } else if collectionViewSize.height - ((cellSize.height / 4) * 3) <= point.y {
                        let baseValue = (point.y - (collectionViewSize.height - ((cellSize.height / 4) * 3))) / ((cellSize.height / 4) * 3)
                        let scale = 1 - baseValue * scaleMode.value
                        let alpha = 1 - baseValue * 0.1
                        scalingProcess($0, scale: scale, alpha: alpha, minimuScale: scaleMode.value, minimumAlpha: alphaMode.value)
                    } else {
                        scalingProcess($0, scale: 1, alpha: 1, minimuScale: scaleMode.value, minimumAlpha: alphaMode.value)
                    }
                }

            case .Horizontal:
                cells.forEach {
                    guard let point = $0.superview?.convertPoint($0.frame.origin, toView: toView) else { return }
                    let cellSize = $0.bounds.size
                    if -cellSize.width / 2 >= point.x {
                        let baseValue = 1 - (point.x / (-cellSize.width / 2))
                        let scale = 1 + baseValue * scaleMode.value
                        let alpha = 1 + baseValue * 0.1
                        scalingProcess($0, scale: scale, alpha: alpha, minimuScale: scaleMode.value, minimumAlpha: alphaMode.value)
                    } else if collectionViewSize.width - ((cellSize.width / 4) * 3) <= point.x {
                        let baseValue = (point.x - (collectionViewSize.width - ((cellSize.width / 4) * 3))) / ((cellSize.width / 4) * 3)
                        let scale = 1 - baseValue * scaleMode.value
                        let alpha = 1 - baseValue * 0.1
                        scalingProcess($0, scale: scale, alpha: alpha, minimuScale: scaleMode.value, minimumAlpha: alphaMode.value)
                    } else {
                        scalingProcess($0, scale: 1, alpha: 1, minimuScale: scaleMode.value, minimumAlpha: alphaMode.value)
                    }
                }
        }
        
        guard let attributes = items as? [UICollectionViewLayoutAttributes] where !items.isEmpty else {
            return super.layoutAttributesForElementsInRect(rect)
        }
        return attributes
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath) else {
            return super.layoutAttributesForItemAtIndexPath(indexPath)
        }
        return attributes
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        /***
        This method is based on this sample.
        http://www.objc.io/issue-5/collection-views-and-uidynamics.html
        ***/
        
        if let collectionView = collectionView, behaviors = dynamicAnimator.behaviors as? [UIAttachmentBehavior] {
            switch scrollDirection {
                case .Vertical:
                    let delta = newBounds.origin.y - collectionView.bounds.origin.y
                    let touchPoint = collectionView.panGestureRecognizer.locationInView(collectionView)
                    for behavior in behaviors {
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
                            
                            dynamicAnimator.updateItemUsingCurrentState(attributes)
                        }
                    }
                
                case .Horizontal:
                    let delta = newBounds.origin.x - collectionView.bounds.origin.x
                    let touchPoint = collectionView.panGestureRecognizer.locationInView(collectionView)
                    for behavior in behaviors {
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
                            
                            dynamicAnimator.updateItemUsingCurrentState(attributes)
                        }
                    }
            }
            return true
        }
        return false
    }
}
