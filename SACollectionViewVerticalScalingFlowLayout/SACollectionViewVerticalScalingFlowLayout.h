//
//  SACollectionViewVerticalScalingFlowLayout.h
//  SACollectionViewVerticalScalingFlowLayout
//
//  Created by 鈴木大貴 on 2015/01/23.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACollectionViewVerticalScalingFlowLayout : UICollectionViewFlowLayout

typedef NS_ENUM(NSInteger, SACollectionViewVerticalScalingFlowLayoutAlphaMode) {
    SACollectionViewVerticalScalingFlowLayoutAlphaModeNone = 0,
    SACollectionViewVerticalScalingFlowLayoutAlphaModeEasy,
    SACollectionViewVerticalScalingFlowLayoutAlphaModeHard
};

typedef NS_ENUM(NSInteger, SACollectionViewVerticalScalingFlowLayoutScaleMode) {
    SACollectionViewVerticalScalingFlowLayoutScaleModeNone = 0,
    SACollectionViewVerticalScalingFlowLayoutScaleModeEasy,
    SACollectionViewVerticalScalingFlowLayoutScaleModeHard
};

@property (assign, nonatomic) SACollectionViewVerticalScalingFlowLayoutScaleMode scaleMode;
@property (assign, nonatomic) SACollectionViewVerticalScalingFlowLayoutAlphaMode alphaMode;


@end
