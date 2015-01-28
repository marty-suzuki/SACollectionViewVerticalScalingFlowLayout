//
//  ViewController.m
//  SACollectionViewVerticalScalingFlowLayoutExample
//
//  Created by 鈴木大貴 on 2015/01/25.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

#import "ViewController.h"
#import "SACollectionViewVerticalScalingCell.h"
#import "SACollectionViewVerticalScalingFlowLayout.h"

@interface ViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

static NSString *const kCellIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.collectionView registerClass:[SACollectionViewVerticalScalingCell class] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.dataSource = self;
    SACollectionViewVerticalScalingFlowLayout *layout = [[SACollectionViewVerticalScalingFlowLayout alloc] init];
    layout.scaleMode = SACollectionViewVerticalScalingFlowLayoutScaleModeHard;
    layout.alphaMode = SACollectionViewVerticalScalingFlowLayoutScaleModeEasy;
    self.collectionView.collectionViewLayout = layout;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewVerticalScalingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    NSInteger number = indexPath.row % 7 + 1;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%@", @(number)]];
    [cell.containerView addSubview:imageView];
    return cell;
}

@end
