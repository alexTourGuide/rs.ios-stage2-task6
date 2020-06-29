//
//  DetailMediaViewController.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/23/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface DetailMediaViewController : UIViewController

@property (nonatomic, strong) PHAsset *mediaItem;

- (instancetype)initWithMediaItem:(PHAsset *)mediaItem;

@end

NS_ASSUME_NONNULL_END
