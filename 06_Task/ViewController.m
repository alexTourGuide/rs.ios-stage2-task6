//
//  ViewController.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/19/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+RequiredColors.h"
#import "SecondTabViewController.h"
#import "ThirdViewController.h"
#import "FirstViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *middle;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *readyLabel;
@property (nonatomic, strong) UIStackView *middleStackView;
@property (nonatomic, strong) UIView *triangleView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    self.view.backgroundColor = [UIColor ReqWhiteColor];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self setupView];
}

#pragma mark - Setup views

- (void)setupView {
    self.header = [UIView new];
    self.header.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.header];
    self.header.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.middle = [UIView new];
    self.middle.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.middle];
    self.middle.translatesAutoresizingMaskIntoConstraints = NO;

    self.footer = [UIView new];
    self.footer.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.footer];
    self.footer.translatesAutoresizingMaskIntoConstraints = NO;

    self.readyLabel = [UILabel new];
    self.readyLabel.text = @"Are you ready?";
    self.readyLabel.textAlignment = NSTextAlignmentCenter;
    self.readyLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightMedium];
    [self.header addSubview:self.readyLabel];
    self.readyLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.middleStackView = [UIStackView new];
    self.middleStackView.axis = UILayoutConstraintAxisHorizontal;
    self.middleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.middleStackView.alignment = UIStackViewAlignmentCenter;
    self.middleStackView.spacing = 30.0;
    
    [self.middle addSubview:self.middleStackView];
    self.middleStackView.translatesAutoresizingMaskIntoConstraints = NO;

    // Setup TriangleView
    self.triangleView = [UIView new];
    self.triangleView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.triangleView.widthAnchor constraintEqualToConstant:70.0],
        [self.triangleView.heightAnchor constraintEqualToConstant:70.0]
    ]];
    // Draw Triangle
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(35.0, 0.0)];
    [trianglePath addLineToPoint:CGPointMake(70.0, 70.0)];
    [trianglePath addLineToPoint:CGPointMake(0.0, 70.0)];
    [trianglePath closePath];

    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70.0, 70.0)];

    view.backgroundColor = [UIColor ReqGreenColor];
    view.layer.mask = triangleMaskLayer;
    [self.triangleView addSubview:view];
    // Animate Triangle
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 5;
    rotationAnimation.repeatCount = 100;
    rotationAnimation.removedOnCompletion = NO;

    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation.z"];

    // Setup SquareView
    self.squareView = [UIView new];
    self.squareView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.squareView.widthAnchor constraintEqualToConstant:70.0],
        [self.squareView.heightAnchor constraintEqualToConstant:70.0]
    ]];
    // Draw Square
    UIBezierPath *squarePath = [UIBezierPath bezierPath];
    [squarePath moveToPoint:CGPointMake(0.0, 0.0)];
    [squarePath addLineToPoint:CGPointMake(70.0, 0.0)];
    [squarePath addLineToPoint:CGPointMake(70.0, 70.0)];
    [squarePath addLineToPoint:CGPointMake(0.0, 70.0)];
    [squarePath closePath];

    CAShapeLayer *squarePathMaskLayer = [CAShapeLayer layer];
    [squarePathMaskLayer setPath:squarePath.CGPath];

    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70.0, 70.0)];
    cView.backgroundColor = [UIColor ReqBlueColor];
    cView.layer.mask = squarePathMaskLayer;
    [self.squareView addSubview:cView];
        
    // Animate Square
    CABasicAnimation *positionAnimation;
    positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(35.0, 35.0 + 7)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(35.0, 35.0 - 7)];
    positionAnimation.duration = 1;
    positionAnimation.autoreverses = YES;
    positionAnimation.repeatCount = 100;
    positionAnimation.removedOnCompletion = NO;

    [cView.layer addAnimation:positionAnimation forKey:@"position"];

    // Setup CircleView
    self.circleView = [UIView new];
    self.circleView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
       [self.circleView.widthAnchor constraintEqualToConstant:70.0],
       [self.circleView.heightAnchor constraintEqualToConstant:70.0]
    ]];
    // Draw Circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 70.0, 70.0)] CGPath]];
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70.0, 70.0)];

    shView.backgroundColor = [UIColor ReqRedColor];
    shView.layer.mask = circleLayer;
    [self.circleView addSubview:shView];
        
    // Animate Circle
    [UIView animateWithDuration:1
             delay:0
           options:UIViewAnimationOptionRepeat
        animations:(void (^)(void)) ^{
            self.circleView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
        completion:^(BOOL finished){
            self.circleView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
        
    [self.middleStackView addArrangedSubview:self.circleView];
    [self.middleStackView addArrangedSubview:self.squareView];
    [self.middleStackView addArrangedSubview:self.triangleView];
   
    // Setup Start Button
    self.startButton = [UIButton new];
    self.startButton.backgroundColor = [UIColor ReqYellowColor];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    [self.startButton setTitleColor:[UIColor ReqBlackColor] forState:UIControlStateNormal];
    self.startButton.layer.cornerRadius = 55.0 / 2;
    
    [self.footer addSubview:self.startButton];
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];

    // Setup constraints
    [self setupConstraints];
}

#pragma mark - Handlers

- (void)startAction {
    UITabBarController *tabBarCo = [UITabBarController new];
    
    FirstViewController *firstTab = [FirstViewController new];
    firstTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"info_unselected"] selectedImage:[UIImage imageNamed:@"info_selected"]];
    
    SecondTabViewController *secTab = [SecondTabViewController new];
    secTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"gallery_unselected"] selectedImage:[UIImage imageNamed:@"gallery_selected"]];
    
    ThirdViewController *thirdTab = [ThirdViewController new];
    thirdTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"home_unselected"] selectedImage:[UIImage imageNamed:@"home_selected"]];
    
    [UIView appearance].tintColor = [UIColor ReqBlackColor];
    tabBarCo.viewControllers = @[firstTab,secTab,thirdTab];
    tabBarCo.selectedViewController = tabBarCo.viewControllers[1];
    tabBarCo.navigationItem.hidesBackButton = YES;
    
    [self.navigationController pushViewController:tabBarCo animated:YES];
}

#pragma mark - Helpers

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.header.heightAnchor constraintEqualToConstant:self.view.bounds.size.height/3],
            
            [self.readyLabel.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.readyLabel.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-50.0],

            [self.middle.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.middle.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.middle.heightAnchor constraintEqualToConstant:self.view.bounds.size.height/3],

            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.topAnchor constraintEqualToAnchor:self.middle.topAnchor],

            [self.footer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            
            [self.startButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:-30.0],
            [self.startButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.startButton.widthAnchor constraintEqualToConstant:280],
            [self.startButton.heightAnchor constraintEqualToConstant:55.0],
    ]];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupView];
}

@end
