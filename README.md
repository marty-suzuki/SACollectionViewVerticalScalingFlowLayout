# SACollectionViewVerticalScalingFlowLayout

[![Version](https://img.shields.io/cocoapods/v/SACollectionViewVerticalScalingFlowLayout.svg?style=flat)](http://cocoadocs.org/docsets/SACollectionViewVerticalScalingFlowLayout)
[![License](https://img.shields.io/cocoapods/l/SACollectionViewVerticalScalingFlowLayout.svg?style=flat)](http://cocoadocs.org/docsets/SACollectionViewVerticalScalingFlowLayout)
[![Platform](https://img.shields.io/cocoapods/p/SACollectionViewVerticalScalingFlowLayout.svg?style=flat)](http://cocoadocs.org/docsets/SACollectionViewVerticalScalingFlowLayout)

## About

SACollectionViewVerticalScalingFlowLayout applies scaling up or down effect to appearing or disappearing cells.

![Alert](./SampleImage/sample.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### From Storyboard or Xib

Go to 'Attributes Inspector' of Storyboard or Xib, and set Layout tab 'Custom'. And set class tab 'SACollectionViewVerticalScalingFlowLayout'.

![Alert](./SampleImage/CollectionView.png)

#### From Code

Write this code at viewDidLoad method and so on.

``` objective-c

    [self.collectionView registerClass:[SACollectionViewVerticalScalingCell class] forCellWithReuseIdentifier:kCellIdentifier];
    SACollectionViewVerticalScalingFlowLayout *layout = [[SACollectionViewVerticalScalingFlowLayout alloc] init];
    layout.scaleMode = SACollectionViewVerticalScalingFlowLayoutScaleModeHard;
    layout.alphaMode = SACollectionViewVerticalScalingFlowLayoutScaleModeEasy;
    self.collectionView.collectionViewLayout = layout;
    
```

## Customization

You can customize scaling and alpha of apearing or disapering cells.

#### For Scale

You can change alpha to set ScaleModeType for scaleMode property of SACollectionViewVerticalScalingFlowLayout.

``` objective-c

	@property (assign, nonatomic) SACollectionViewVerticalScalingFlowLayoutScaleMode scaleMode;

	SACollectionViewVerticalScalingFlowLayoutScaleModeNone
    SACollectionViewVerticalScalingFlowLayoutScaleModeEasy
    SACollectionViewVerticalScalingFlowLayoutScaleModeHard

```

#### For Alpha

You can change alpha to set AlphaModeType for alphaMode property of SACollectionViewVerticalScalingFlowLayout.

``` objective-c
	
	@property (assign, nonatomic) SACollectionViewVerticalScalingFlowLayoutAlphaMode alphaMode;

	SACollectionViewVerticalScalingFlowLayoutAlphaModeNone
    SACollectionViewVerticalScalingFlowLayoutAlphaModeEasy
    SACollectionViewVerticalScalingFlowLayoutAlphaModeHard

```

#### For Cell

You use containerView instead of contentView like this code, then you can add what kind of view you want to add.

``` objective-c

	SACollectionViewVerticalScalingCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = [UIImage imageNamed:@"cat"];
    [cell.containerView addSubview:imageView];

```

## Requirements
- iOS 7.0 and greater
- ARC

## Installation

SACollectionViewVerticalScalingFlowLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "SACollectionViewVerticalScalingFlowLayout"

## Author

Taiki Suzuki, s1180183@gmail.com

## License

SACollectionViewVerticalScalingFlowLayout is available under the MIT license. See the LICENSE file for more info.

