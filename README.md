# SACollectionViewVerticalScalingFlowLayout

[![Version](https://img.shields.io/cocoapods/v/SACollectionViewVerticalScalingFlowLayout.svg?style=flat)](http://cocoadocs.org/docsets/SACollectionViewVerticalScalingFlowLayout)
[![License](https://img.shields.io/cocoapods/l/SACollectionViewVerticalScalingFlowLayout.svg?style=flat)](http://cocoadocs.org/docsets/SACollectionViewVerticalScalingFlowLayout)
[![Platform](https://img.shields.io/cocoapods/p/SACollectionViewVerticalScalingFlowLayout.svg?style=flat)](http://cocoadocs.org/docsets/SACollectionViewVerticalScalingFlowLayout)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/szk-atmosphere/sacollectionviewverticalscalingflowlayout/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## About

SACollectionViewVerticalScalingFlowLayout applies scaling up or down effect to appearing or disappearing cells. In addition, animation of UIDynamics applies each cell.

![sample1](./SampleImage/sample1.gif) ![sample2](./SampleImage/sample2.gif)

[ManiacDev.com](https://maniacdev.com/) referred.  
[https://maniacdev.com/2015/07/open-source-uicollectionview-layout-that-automatically-scales-images-scrolling-inout-of-view](https://maniacdev.com/2015/07/open-source-uicollectionview-layout-that-automatically-scales-images-scrolling-inout-of-view)

## Features

- [x] Vertical Scaling
- [x] Rewrite in Swift 
- [x] Support Horizonal Scaling
- [x] Supoort Swift2.3
- [x] Support Swift3

## Installation

#### CocoaPods

SACollectionViewVerticalScalingFlowLayout is available through [CocoaPods](http://cocoapods.org). If you have cocoapods 1.1.0.rc.2 or greater, you can install
it, simply add the following line to your Podfile:

    pod "SACollectionViewVerticalScalingFlowLayout"


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### From Storyboard or Xib

Go to 'Attributes Inspector' of Storyboard or Xib, and set Layout tab 'Custom'. And set class tab 'SACollectionViewVerticalScalingFlowLayout'.

![Alert](./SampleImage/CollectionView.png)

#### From Code

Write this code at viewDidLoad method and so on.

```swift

collectionView.registerClass(SACollectionViewVerticalScalingCell.self, forCellWithReuseIdentifier:kCellIdentifier)
let layout = SACollectionViewVerticalScalingFlowLayout()
layout.scaleMode = .hard
layout.alphaMode = .easy
layout.scrollDirection = .Vertical
collectionView.collectionViewLayout = layout
    
```

if you want to use Horizontal mode.

```swift

layout.scrollDirection = .horizontal

```

## Customization

You can customize scaling and alpha of apearing or disapering cells.

#### For Scale

You can change alpha to set ScaleModeType for scaleMode property of SACollectionViewVerticalScalingFlowLayout.(default: .easy)

```swift

var scaleMode: SACollectionViewVerticalScalingFlowLayoutScaleMode

enum SACollectionViewVerticalScalingFlowLayoutScaleMode {
    case none, easy, hard
}


```

#### For Alpha

You can change alpha to set AlphaModeType for alphaMode property of SACollectionViewVerticalScalingFlowLayout. (default: .easy)

``` swift
	
var alphaMode: SACollectionViewVerticalScalingFlowLayoutScaleMode
	
enum SACollectionViewVerticalScalingFlowLayoutAlphaMode {
    case none, easy, hard
}

```

#### For Cell

You use containerView instead of contentView like this code, then you can add what kind of view you want to add.

``` swift

let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath)
let imageView = UIImageView(frame: cell.bounds)
imageView.image = UIImage(named: "cat")
cell.containerView?.addSubview(imageView)

```

## Requirements
- Xcode 8 or greater
- iOS 8 or greater
- ARC

## Author

Taiki Suzuki, s1180183@gmail.com

## License

SACollectionViewVerticalScalingFlowLayout is available under the MIT license. See the LICENSE file for more info.

