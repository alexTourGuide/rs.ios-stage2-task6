//
//  MediaTableViewCell.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/21/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *previewView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *iconMedia;
@property (nonatomic, strong) UILabel *detailInfo;

- (void)configureWithMediaItem:(PHAsset *)mediaItem;

@end

NS_ASSUME_NONNULL_END
