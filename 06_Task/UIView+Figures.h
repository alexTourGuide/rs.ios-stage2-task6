//
//  UIView+Figures.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/28/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Figures)

+ (UIView *)createTriangleWithSide:(float)side andColor:(UIColor *)color;
+ (UIView *)createSquareWithSide:(float)side andColor:(UIColor *)color;
+ (UIView *)createCircleWithSide:(float)side andColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
