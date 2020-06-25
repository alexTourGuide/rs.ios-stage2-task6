//
//  UIColor+RequiredColors.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/19/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RequiredColors)

+ (UIColor *)ReqBlackColor;
+ (UIColor *)ReqWhiteColor;
+ (UIColor *)ReqRedColor;
+ (UIColor *)ReqBlueColor;
+ (UIColor *)ReqGreenColor;
+ (UIColor *)ReqYellowColor;
+ (UIColor *)ReqGrayColor;
+ (UIColor *)ReqYellowHighlightedColor;

+ (UIColor *)colorWithHexString:(NSString *) hexString;

@end

NS_ASSUME_NONNULL_END
