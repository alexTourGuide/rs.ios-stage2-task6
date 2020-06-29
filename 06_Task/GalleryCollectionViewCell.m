//
//  GalleryCollectionViewCell.m
//  UICollectionViewDemo2
//
//  Created by Alexander Porshnev on 5/4/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "GalleryCollectionViewCell.h"
#import <Photos/Photos.h>

@implementation GalleryCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)configureWithItem:(PHAsset *)item {
    PHAsset *asset = item;
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    NSInteger retinaMultiplier = [[UIScreen mainScreen] scale];
    CGSize retinaSquare = CGSizeMake(self.imageView.bounds.size.width * retinaMultiplier, self.imageView.bounds.size.height * retinaMultiplier);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:retinaSquare
                                              contentMode:PHImageContentModeAspectFit
                                                  options:requestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
         dispatch_async(dispatch_get_main_queue(), ^(void){
             switch ([item mediaType]) {
                 case PHAssetMediaTypeImage:
                     self.imageView.image = [UIImage imageWithCGImage:result.CGImage
                                                                scale:retinaMultiplier
                                                          orientation:result.imageOrientation];
                     break;
                 case PHAssetMediaTypeVideo:
                      self.imageView.image = [UIImage imageWithCGImage:result.CGImage
                                                                 scale:retinaMultiplier
                      orientation:result.imageOrientation];
                     break;
                 case PHAssetMediaTypeAudio:
                     self.imageView.image = [UIImage imageNamed:@"audio"];
                     break;
                 case PHAssetMediaTypeUnknown:
                     self.imageView.image = [UIImage imageNamed:@"other"];
                     break;
             }
         });
     }];
}


@end
