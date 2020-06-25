//
//  MediaItem.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/21/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaItem : NSObject

@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *iconMediaImage;
@property (nonatomic, strong) NSString *detailInfo;

- (instancetype)initWithTitle:(NSString *)item
                 previewImage:(UIImage *)previeImage
                 iconImage:(UIImage *)iconMediaImage
                detailInfo:(NSString *)detailInfo;

@end

NS_ASSUME_NONNULL_END
