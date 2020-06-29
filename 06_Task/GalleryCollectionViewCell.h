//
//  GalleryCollectionViewCell.h
//  UICollectionViewDemo2
//
//  Created by Alexander Porshnev on 5/4/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface GalleryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

- (void)configureWithItem:(PHAsset *)item;

@end

NS_ASSUME_NONNULL_END
