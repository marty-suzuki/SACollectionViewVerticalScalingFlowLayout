//
//  SACollectionViewVerticalScalingFlowLayout.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/06/07.
//
//

import UIKit

struct Const {
    static let easyValue: CGFloat = 0.05
    static let hardValue: CGFloat = 0.2
}

public enum SACollectionViewVerticalScalingFlowLayoutAlphaMode {
    case none, easy, hard
    var value: CGFloat {
        switch self {
        case .none: return 0
        case .easy: return Const.easyValue
        case .hard: return Const.hardValue
        }
    }
}

public enum SACollectionViewVerticalScalingFlowLayoutScaleMode {
    case none, easy, hard
    var value: CGFloat {
        switch self {
            case .none: return 0
            case .easy: return Const.easyValue
            case .hard: return Const.hardValue
        }
    }
}

//MARK: - Initialize Methods
open class SACollectionViewVerticalScalingFlowLayout : UICollectionViewFlowLayout {
    
    fileprivate struct Const {
        static let minimumInteritemSpacing: CGFloat = 25
        static let minimumLineSpacing: CGFloat = 25
    }
    
    open var scaleMode: SACollectionViewVerticalScalingFlowLayoutAlphaMode = .easy
    open var alphaMode: SACollectionViewVerticalScalingFlowLayoutScaleMode = .easy
    
    fileprivate lazy var dynamicAnimator: UIDynamicAnimator = {
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
    fileprivate func configuration() {
        minimumInteritemSpacing = Const.minimumInteritemSpacing
        minimumLineSpacing = Const.minimumLineSpacing
        let width = UIScreen.main.bounds.size.width
        itemSize = CGSize(width: width - Const.minimumInteritemSpacing * 2, height: width - Const.minimumLineSpacing * 2)
        sectionInset = UIEdgeInsets(top: Const.minimumLineSpacing, left: Const.minimumInteritemSpacing, bottom: Const.minimumLineSpacing, right: Const.minimumInteritemSpacing)
    }
    
    fileprivate func scalingProcess(_ cell: SACollectionViewVerticalScalingCell, scale: CGFloat, alpha: CGFloat, minimuScale: CGFloat, minimumAlpha: CGFloat) {
        if scaleMode != .none {
            let scale = max(0, min(1, max(minimuScale, scale)))
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            cell.containerView?.transform = transform
            cell.shadeTransform = transform
        }
        
        if alphaMode != .none {
            cell.shadeAlpha = (1 - max(0 ,min(1, max(minimumAlpha, alpha)))) * 10
        }
    }
}

//MARK: - Override Methods
extension SACollectionViewVerticalScalingFlowLayout {
    override open func prepare() {
        super.prepare()
        
        guard
            dynamicAnimator.behaviors.count < 1,
            let contentSize = collectionView?.contentSize,
            let items = super.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        else { return }
        
        items.forEach {
            let behaviour = UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center)
            behaviour.length = 0
            behaviour.damping = 0.8
            behaviour.frequency = 1
            dynamicAnimator.addBehavior(behaviour)
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let cells = collectionView?.visibleCells as? [SACollectionViewVerticalScalingCell],
            let toView = collectionView?.superview,
            let collectionViewSize = collectionView?.bounds.size
        else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let items = dynamicAnimator.items(in: rect)
        switch scrollDirection {
            case .vertical:
                cells.forEach {
                    guard let point = $0.superview?.convert($0.frame.origin, to: toView) else  { return }
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

            case .horizontal:
                cells.forEach {
                    guard let point = $0.superview?.convert($0.frame.origin, to: toView) else { return }
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
        
        guard let attributes = items as? [UICollectionViewLayoutAttributes] , !items.isEmpty else {
            return super.layoutAttributesForElements(in: rect)
        }
        return attributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = dynamicAnimator.layoutAttributesForCell(at: indexPath) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        return attributes
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        /***
        This method is based on this sample.
        http://www.objc.io/issue-5/collection-views-and-uidynamics.html
        ***/
        
        if let collectionView = collectionView, let behaviors = dynamicAnimator.behaviors as? [UIAttachmentBehavior] {
            switch scrollDirection {
                case .vertical:
                    let delta = newBounds.origin.y - collectionView.bounds.origin.y
                    let touchPoint = collectionView.panGestureRecognizer.location(in: collectionView)
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
                            
                            dynamicAnimator.updateItem(usingCurrentState: attributes)
                        }
                    }
                
                case .horizontal:
                    let delta = newBounds.origin.x - collectionView.bounds.origin.x
                    let touchPoint = collectionView.panGestureRecognizer.location(in: collectionView)
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
                            
                            dynamicAnimator.updateItem(usingCurrentState: attributes)
                        }
                    }
            }
            return true
        }
        return false
    }
}
