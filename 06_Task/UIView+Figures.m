//
//  UIView+Figures.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/28/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "UIView+Figures.h"

@implementation UIView (Figures)

+ (UIView *)createTriangleWithSide:(float)side andColor:(UIColor *)color {
    UIView *triangle = [UIView new];
    triangle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [triangle.widthAnchor constraintEqualToConstant:side],
        [triangle.heightAnchor constraintEqualToConstant:side]
    ]];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(side/2.0, 0.0)];
    [trianglePath addLineToPoint:CGPointMake(side, side)];
    [trianglePath addLineToPoint:CGPointMake(0.0, side)];
    [trianglePath closePath];

    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];

    triangle.backgroundColor = color;
    triangle.layer.mask = triangleMaskLayer;
    
    return triangle;
}

+ (UIView *)createSquareWithSide:(float)side andColor:(UIColor *)color {
    UIView *square = [UIView new];
    square.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [square.widthAnchor constraintEqualToConstant:side],
        [square.heightAnchor constraintEqualToConstant:side]
    ]];
    
    UIBezierPath *squarePath = [UIBezierPath bezierPath];
    [squarePath moveToPoint:CGPointMake(0.0, 0.0)];
    [squarePath addLineToPoint:CGPointMake(side, 0.0)];
    [squarePath addLineToPoint:CGPointMake(side, side)];
    [squarePath addLineToPoint:CGPointMake(0.0, side)];
    [squarePath closePath];

    CAShapeLayer *squarePathMaskLayer = [CAShapeLayer layer];
    [squarePathMaskLayer setPath:squarePath.CGPath];

    square.backgroundColor = color;
    square.layer.mask = squarePathMaskLayer;
    return square;
}

+ (UIView *)createCircleWithSide:(float)side andColor:(UIColor *)color {
    UIView *circle = [UIView new];
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
       [circle.widthAnchor constraintEqualToConstant:side],
       [circle.heightAnchor constraintEqualToConstant:side]
    ]];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)] CGPath]];

    circle.backgroundColor = color;
    circle.layer.mask = circleLayer;
    return circle;
}

@end
