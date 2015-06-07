//
//  SACollectionViewVerticalScalingFlowLayout.m
//  SACollectionViewVerticalScalingFlowLayout
//
//  Created by 鈴木大貴 on 2015/01/23.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

//#import "SACollectionViewVerticalScalingFlowLayout.h"
//#import "SACollectionViewVerticalScalingCell.h"
//
//@interface SACollectionViewVerticalScalingFlowLayout ()
//
//@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
//
//@end
//
//@implementation SACollectionViewVerticalScalingFlowLayout
//
//static CGFloat const kMinimumInteritemSpacing = 25.0f;
//static CGFloat const kMinimumLineSpacing = 25.0f;
//
//static CGFloat const kEasyValue = 0.05;
//static CGFloat const kHardValue = 0.2;
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        [self initialize];
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self initialize];
//    }
//    return self;
//}
//
//#pragma  mark - SACollectionViewVerticalScalingFlowLayout Override Methods
//- (void)prepareLayout {
//    /***
//        This method is based on this sample.
//        http://www.objc.io/issue-5/collection-views-and-uidynamics.html
//     ***/
//
//    
//    [super prepareLayout];
//    
//    if (self.collectionView) {
//        CGSize contentSize = self.collectionView.contentSize;
//        
//        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
//        if (self.dynamicAnimator.behaviors.count < 1) {
//            [items enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
//                UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
//                behaviour.length = 0.0f;
//                behaviour.damping = 0.8f;
//                behaviour.frequency = 1.0f;
//                [self.dynamicAnimator addBehavior:behaviour];
//            }];
//        }
//    }
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *items = [self.dynamicAnimator itemsInRect:rect];
//    
//    NSArray *cells = [self.collectionView visibleCells];
//    CGSize collectionViewSize = self.collectionView.frame.size;
//    void(^scallingBlock)(SACollectionViewVerticalScalingCell *, CGFloat, CGFloat, CGFloat, CGFloat) = ^( SACollectionViewVerticalScalingCell *cell, CGFloat scale, CGFloat alphaValue, CGFloat minimuScaleValue, CGFloat minimumAlphaValue) {
//        
//        if (self.scaleMode != SACollectionViewVerticalScalingFlowLayoutScaleModeNone) {
//            if (scale > 1.0f) {
//                scale = 1.0f;
//            } else if (scale < minimuScaleValue) {
//                scale = minimuScaleValue;
//            }
//            
//            cell.containerView.transform = CGAffineTransformMakeScale(scale, scale);
//            cell.shadeTransform = CGAffineTransformMakeScale(scale, scale);
//        }
//        if (self.alphaMode != SACollectionViewVerticalScalingFlowLayoutAlphaModeNone) {
//            if (alphaValue > 1.0f) {
//                alphaValue = 1.0f;
//            } else if (alphaValue < minimumAlphaValue) {
//                alphaValue = minimumAlphaValue;
//            }
//            
//            cell.shadeAlpha = (1.0f - alphaValue) * 10.0f;
//        }
//    };
//    
//    CGFloat scaleValue = kEasyValue;
//    switch (self.scaleMode) {
//        case SACollectionViewVerticalScalingFlowLayoutScaleModeHard:
//            scaleValue = kHardValue;
//            break;
//            
//        case SACollectionViewVerticalScalingFlowLayoutScaleModeNone:
//        case SACollectionViewVerticalScalingFlowLayoutScaleModeEasy:
//            break;
//    }
//    
//    CGFloat alphaValue = kEasyValue;
//    switch (self.alphaMode) {
//        case SACollectionViewVerticalScalingFlowLayoutAlphaModeHard:
//            alphaValue = kHardValue;
//            break;
//            
//        case SACollectionViewVerticalScalingFlowLayoutAlphaModeNone:
//        case SACollectionViewVerticalScalingFlowLayoutAlphaModeEasy:
//            break;
//    }
//    
//    [cells enumerateObjectsUsingBlock:^(SACollectionViewVerticalScalingCell *cell, NSUInteger index, BOOL *stop) {
//        CGPoint point = [cell.superview convertPoint:cell.frame.origin toView:self.collectionView.superview];
//        CGSize cellSize = cell.frame.size;
//        if ((-cellSize.height / 2.0f) >= point.y) {
//            CGFloat scale = 1.0f + (1.0f - (point.y / (-cellSize.height / 2.0f))) * scaleValue;
//            CGFloat alpha = 1.0f + (1.0f - (point.y / (-cellSize.height / 2.0f))) * 0.1f;
//            scallingBlock(cell, scale, alpha, scaleValue, alphaValue);
//        } else if (collectionViewSize.height - (cellSize.height / 4.0f * 3.0f) <= point.y) {
//            CGFloat scale = 1.0f - ((point.y - (collectionViewSize.height - (cellSize.height / 4.0f * 3.0f))) / (cellSize.height / 4.0f * 3.0f)) * scaleValue;
//            CGFloat alpha = 1.0f - ((point.y - (collectionViewSize.height - (cellSize.height / 4.0f * 3.0f))) / (cellSize.height / 4.0f * 3.0f)) * 0.1f;
//            scallingBlock(cell, scale, alpha, scaleValue, alphaValue);
//        }
//    }];
//    
//    scallingBlock = nil;
//    
//    return items.count < 1 ? [super layoutAttributesForElementsInRect:rect] : items;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewLayoutAttributes *attributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
//    return attributes != nil ? attributes : [super layoutAttributesForItemAtIndexPath:indexPath];
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    /***
//        This method is based on this sample.
//        http://www.objc.io/issue-5/collection-views-and-uidynamics.html
//     ***/
//    
//    if (self.collectionView == nil) {
//        return NO;
//    }
//    
//    CGFloat delta = newBounds.origin.y - self.collectionView.bounds.origin.y;
//    CGPoint touchPoint = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
//    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *behavior, NSUInteger index, BOOL *stop) {
//        CGFloat yDistanceFromTouch = fabs(touchPoint.y - behavior.anchorPoint.y);
//        CGFloat xDistanceFromTouch = fabs(touchPoint.x - behavior.anchorPoint.x);
//        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
//        
//        UICollectionViewLayoutAttributes *attributes = behavior.items.firstObject;
//        if (attributes) {
//            CGPoint center = attributes.center;
//            if (delta < 0) {
//                center.y += MAX(delta, delta * scrollResistance);
//            } else {
//                center.y += MIN(delta, delta * scrollResistance);
//            }
//            attributes.center = center;
//            
//            [self.dynamicAnimator updateItemUsingCurrentState:attributes];
//        }
//    }];
//    
//    return YES;
//}
//
//#pragma  mark - SACollectionViewVerticalScalingFlowLayout Private Methods
//- (void)initialize {
//    self.scaleMode = SACollectionViewVerticalScalingFlowLayoutAlphaModeEasy;
//    self.alphaMode = SACollectionViewVerticalScalingFlowLayoutAlphaModeEasy;
//    
//    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
//    self.minimumInteritemSpacing = kMinimumInteritemSpacing;
//    self.minimumLineSpacing = kMinimumLineSpacing;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    self.itemSize = CGSizeMake(width - kMinimumInteritemSpacing * 2.0f, width - kMinimumLineSpacing * 2.0f);
//    self.sectionInset = UIEdgeInsetsMake(kMinimumLineSpacing, kMinimumInteritemSpacing, kMinimumLineSpacing, kMinimumInteritemSpacing);
//}
//
//@end