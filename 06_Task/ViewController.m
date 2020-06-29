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
#import "Constants.h"
#import "UIView+Figures.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *upperView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *readyLabel;
@property (nonatomic, strong) UIStackView *middleStackView;
@property (nonatomic, strong) UIView *triangleView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation ViewController

#pragma mark - Life cycle's methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor requiredWhiteColor];
    [self setupView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self startFiguresAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopFiguresAnimations];
}

#pragma mark - Setup views

- (void)setupView {
    [self setupContainers];
    [self setupFigures];
    [self setupStartButton];
    [self setupConstraints];
}

#pragma mark - Handlers

- (void)startAction {
    UITabBarController *tabBarCo = [UITabBarController new];
    
    FirstViewController *firstTab = [FirstViewController new];
    firstTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"info_unselected"] selectedImage:[UIImage imageNamed:@"info_selected"]];
    
    SecondTabViewController *secTab = [SecondTabViewController new];
    secTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"gallery_unselected"] selectedImage:[UIImage imageNamed:@"gallery_selected"]];
    secTab.navigationItem.title = @"Gallery";
    
    ThirdViewController *thirdTab = [ThirdViewController new];
    thirdTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"home_unselected"] selectedImage:[UIImage imageNamed:@"home_selected"]];
    secTab.navigationItem.title = @"RSChool Task 6";
    
    [UIView appearance].tintColor = [UIColor requiredBlackColor];
    tabBarCo.viewControllers = @[firstTab,secTab,thirdTab];
    tabBarCo.selectedViewController = tabBarCo.viewControllers[1];
    tabBarCo.navigationItem.hidesBackButton = YES;
    
    [self.navigationController pushViewController:tabBarCo animated:YES];
}

#pragma mark - Helpers

- (void)setupContainers {
    self.upperView = [UIView new];
    self.upperView.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.upperView];
    self.upperView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.middleView = [UIView new];
    self.middleView.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.middleView];
    self.middleView.translatesAutoresizingMaskIntoConstraints = NO;

    self.footerView = [UIView new];
    self.footerView.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.footerView];
    self.footerView.translatesAutoresizingMaskIntoConstraints = NO;

    self.readyLabel = [UILabel new];
    self.readyLabel.text = @"Are you ready?";
    self.readyLabel.textAlignment = NSTextAlignmentCenter;
    self.readyLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightMedium];
    [self.upperView addSubview:self.readyLabel];
    self.readyLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.middleStackView = [UIStackView new];
    self.middleStackView.axis = UILayoutConstraintAxisHorizontal;
    self.middleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.middleStackView.alignment = UIStackViewAlignmentCenter;
    self.middleStackView.spacing = 30.0;
    
    [self.middleView addSubview:self.middleStackView];
    self.middleStackView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupFigures {
    self.triangleView = [UIView createTriangleWithSide:kFiguresNormal andColor:[UIColor requiredGreenColor]];
    self.squareView = [UIView createSquareWithSide:kFiguresNormal andColor:[UIColor requiredBlueColor]];
    self.circleView = [UIView createCircleWithSide:kFiguresNormal andColor:[UIColor requiredRedColor]];
    
    // Add them to arranged subviews
    [self.middleStackView addArrangedSubview:self.circleView];
    [self.middleStackView addArrangedSubview:self.squareView];
    [self.middleStackView addArrangedSubview:self.triangleView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.upperView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.upperView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.upperView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.upperView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.3],
        
        [self.readyLabel.centerXAnchor constraintEqualToAnchor:self.upperView.centerXAnchor],
        [self.readyLabel.bottomAnchor constraintEqualToAnchor:self.upperView.bottomAnchor constant:-50.0],

        [self.middleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.middleView.topAnchor constraintEqualToAnchor:self.upperView.bottomAnchor],
        [self.middleView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.middleView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.3],

        [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middleView.centerXAnchor],
        [self.middleStackView.topAnchor constraintEqualToAnchor:self.middleView.topAnchor],

        [self.footerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.footerView.topAnchor constraintEqualToAnchor:self.middleView.bottomAnchor],
        [self.footerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.footerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.startButton.centerYAnchor constraintEqualToAnchor:self.footerView.centerYAnchor constant:-30.0],
        [self.startButton.centerXAnchor constraintEqualToAnchor:self.footerView.centerXAnchor],
        [self.startButton.widthAnchor constraintEqualToConstant:280],
        [self.startButton.heightAnchor constraintEqualToConstant:55.0]
    ]];
}

- (void)startFiguresAnimations {
    // Animate Triangle
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 5;
    rotationAnimation.repeatCount = 100;
    rotationAnimation.removedOnCompletion = NO;
    [self.triangleView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation.z"];
    
    // Animate Square
    CABasicAnimation *positionAnimation;
    positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(133.0, 35.0 + 7)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(133.0, 35.0 - 7)];
    positionAnimation.duration = 1;
    positionAnimation.autoreverses = YES;
    positionAnimation.repeatCount = 100;
    positionAnimation.removedOnCompletion = NO;
    [self.squareView.layer addAnimation:positionAnimation forKey:@"position"];
    
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
}

- (void)stopFiguresAnimations {
    [self.triangleView.layer removeAnimationForKey:@"transform.rotation.z"];
    [self.squareView.layer removeAnimationForKey:@"position"];
    [self.circleView.layer removeAllAnimations];
}

- (void)setupStartButton {
    self.startButton = [UIButton new];
    self.startButton.accessibilityIdentifier = @"startButton";
    self.startButton.backgroundColor = [UIColor requiredYellowColor];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    [self.startButton setTitleColor:[UIColor requiredBlackColor] forState:UIControlStateNormal];
    self.startButton.layer.cornerRadius = 55.0 / 2;
    
    [self.footerView addSubview:self.startButton];
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateViewConstraints];
}

@end
