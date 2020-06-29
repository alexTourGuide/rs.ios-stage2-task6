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

+ (UIColor *)requiredBlackColor;
+ (UIColor *)requiredWhiteColor;
+ (UIColor *)requiredRedColor;
+ (UIColor *)requiredBlueColor;
+ (UIColor *)requiredGreenColor;
+ (UIColor *)requiredYellowColor;
+ (UIColor *)requiredGrayColor;
+ (UIColor *)requiredYellowHighlightedColor;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
