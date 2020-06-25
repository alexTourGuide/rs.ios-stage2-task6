//
//  DetailMediaViewController.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/23/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailMediaViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *modificationDate;
@property (nonatomic, strong) NSString *mediaType;

- (instancetype)initWithImage:(UIImage *)image withFilename:(NSString *)filename withCreationDate:(NSDate *)creationDate withModificationDate:(NSDate *)modificationDate withMediaType:(NSString *)mediaType;

@end

NS_ASSUME_NONNULL_END
