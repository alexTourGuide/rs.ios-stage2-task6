//
//  MediaItem.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/21/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "MediaItem.h"

@implementation MediaItem

- (instancetype)initWithTitle:(NSString *)item previewImage:(UIImage *)previeImage iconImage:(UIImage *)iconMediaImage detailInfo:(NSString *)detailInfo {
    self = [super init];
    if (self) {
        _title = item;
        _previewImage = previeImage;
        _iconMediaImage = iconMediaImage;
        _detailInfo = detailInfo;
    }
    return self;
}

@end
