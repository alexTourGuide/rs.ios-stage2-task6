//
//  ThirdViewController.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/20/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "ThirdViewController.h"
#import "UIColor+RequiredColors.h"
#import "ViewController.h"
#import "Constants.h"

@interface ThirdViewController ()

@property (nonatomic, strong) UIView *upperHeader;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *middle;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *titleHeader;
@property (nonatomic, strong) UIImageView *appleImageView;
@property (nonatomic, strong) UILabel *nameOfDevice;
@property (nonatomic, strong) UILabel *modelOfDevice;
@property (nonatomic, strong) UILabel *deviceVersion;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UIButton *openGitCVButton;
@property (nonatomic, strong) UIButton *goToStartButton;
@property (nonatomic, strong) UIStackView *middleStackView;
@property (nonatomic, strong) UIView *triangleView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *squareView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor ReqYellowColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self setupViews];
}

#pragma mark - Setup views

- (void)setupViews {
    self.upperHeader = [UIView new];
    self.upperHeader.backgroundColor = [UIColor ReqYellowColor];
    [self.view addSubview:self.upperHeader];
    self.upperHeader.translatesAutoresizingMaskIntoConstraints = NO;

    self.titleHeader = [UILabel new];
    self.titleHeader.text = @"RSSchool Task 6";
    self.titleHeader.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
    [self.upperHeader addSubview:self.titleHeader];
    self.titleHeader.translatesAutoresizingMaskIntoConstraints = NO;

    self.header = [UIView new];
    self.header.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.header];
    self.header.translatesAutoresizingMaskIntoConstraints = NO;

    self.appleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple"]];
    [self.header addSubview:self.appleImageView];
    self.appleImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.nameOfDevice = [UILabel new];
    self.nameOfDevice.text = [UIDevice currentDevice].name;
    [self.header addSubview:self.nameOfDevice];
    self.nameOfDevice.translatesAutoresizingMaskIntoConstraints = NO;

    self.modelOfDevice = [UILabel new];
    self.modelOfDevice.text = [UIDevice currentDevice].model;
    [self.header addSubview:self.modelOfDevice];
    self.modelOfDevice.translatesAutoresizingMaskIntoConstraints = NO;

    self.deviceVersion = [UILabel new];
    self.deviceVersion.text = [NSString stringWithFormat:@"%@ %@", UIDevice.currentDevice.systemName, UIDevice.currentDevice.systemVersion];
    [self.header addSubview:self.deviceVersion];
    self.deviceVersion.translatesAutoresizingMaskIntoConstraints = NO;

    self.firstLineView = [UIView new];
    self.firstLineView.backgroundColor = [UIColor ReqGrayColor];
    [self.header addSubview:self.firstLineView];
    self.firstLineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.middle = [UIView new];
    self.middle.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.middle];
    self.middle.translatesAutoresizingMaskIntoConstraints = NO;

    self.middleStackView = [UIStackView new];
    self.middleStackView.axis = (([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) && ((int)[[UIScreen mainScreen] nativeBounds].size.height <= 1335)) ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    self.middleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.middleStackView.alignment = UIStackViewAlignmentCenter;
    self.middleStackView.spacing = 20.0;
    
    [self.middle addSubview:self.middleStackView];
    self.middleStackView.translatesAutoresizingMaskIntoConstraints = NO;

[self setupFigures];
        
    [self.middleStackView addArrangedSubview:self.circleView];
    [self.middleStackView addArrangedSubview:self.squareView];
    [self.middleStackView addArrangedSubview:self.triangleView];
    
    self.secondLineView = [UIView new];
    self.secondLineView.backgroundColor = [UIColor ReqGrayColor];
    [self.middle addSubview:self.secondLineView];
    self.secondLineView.translatesAutoresizingMaskIntoConstraints = NO;

    self.footer = [UIView new];
    self.footer.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.footer];
    self.footer.translatesAutoresizingMaskIntoConstraints = NO;

    self.openGitCVButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openGitCVButton.backgroundColor = [UIColor ReqYellowColor];
    [self.openGitCVButton setTitle:@"Open Git CV" forState:UIControlStateNormal];
    self.openGitCVButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.openGitCVButton setTitleColor:[UIColor ReqBlackColor] forState:UIControlStateNormal];
    self.openGitCVButton.layer.cornerRadius = 55.0 / 2;
    [self.footer addSubview:self.openGitCVButton];
    self.openGitCVButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.openGitCVButton addTarget:self action:@selector(openGitCV) forControlEvents:UIControlEventTouchUpInside];

    self.goToStartButton = [[UIButton alloc] init];
    self.goToStartButton.backgroundColor = [UIColor ReqRedColor];
    [self.goToStartButton setTitle:@"Go to start" forState:UIControlStateNormal];
    self.goToStartButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.goToStartButton setTitleColor:[UIColor ReqWhiteColor] forState:UIControlStateNormal];
    self.goToStartButton.layer.cornerRadius = 55.0 / 2;
    [self.footer addSubview:self.goToStartButton];
    self.goToStartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.goToStartButton addTarget:self action:@selector(goToStart) forControlEvents:UIControlEventTouchUpInside];
    
    // Setup constraints
        if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) && ((int)[[UIScreen mainScreen] nativeBounds].size.height <= 1335)) {
            [NSLayoutConstraint activateConstraints:@[
                [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],

                [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
                [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],
            
                [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [self.header.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
                [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [self.header.heightAnchor constraintEqualToConstant:self.view.frame.size.height/3.8],
                
                [self.appleImageView.heightAnchor constraintEqualToConstant:100.0],
                [self.appleImageView.widthAnchor constraintEqualToConstant:90.0],
                [self.appleImageView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:50.0],
                [self.appleImageView.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],

                [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:-30.0],
                [self.nameOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],

                [self.modelOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],
                [self.modelOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
                
                [self.deviceVersion.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:30.0],
                [self.deviceVersion.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],

                [self.secondLineView.leadingAnchor constraintEqualToAnchor:self.middle.leadingAnchor constant:50.0],
                [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor constant:-50.0],
                [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
                [self.secondLineView.heightAnchor constraintEqualToConstant:3.0],

                [self.middle.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [self.middle.topAnchor constraintEqualToAnchor:self.header.bottomAnchor],
                [self.middle.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [self.middle.heightAnchor constraintEqualToConstant:self.view.frame.size.height/3.5],

                [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
                [self.middleStackView.topAnchor constraintEqualToAnchor:self.middle.topAnchor],
                [self.middleStackView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],

                [self.firstLineView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:50.0],
                [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor constant:-50.0],
                [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor],
                [self.firstLineView.heightAnchor constraintEqualToConstant:3.0],

                [self.footer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [self.footer.topAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
                [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [self.footer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                
                [self.openGitCVButton.topAnchor constraintEqualToAnchor:self.footer.topAnchor constant:20.0],
                [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
                [self.openGitCVButton.widthAnchor constraintEqualToConstant:300.0],
                [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],

                [self.goToStartButton.topAnchor constraintEqualToAnchor:self.openGitCVButton.bottomAnchor constant:20.0],
                [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
                [self.goToStartButton.widthAnchor constraintEqualToConstant:300.0],
                [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
            ]];
        } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:90.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.bottomAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor constant:-18.0],
        
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.header.heightAnchor constraintEqualToConstant:self.view.frame.size.height/3.5],
            
            [self.appleImageView.heightAnchor constraintEqualToConstant:100.0],
            [self.appleImageView.widthAnchor constraintEqualToConstant:90.0],
            [self.appleImageView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:50.0],
            [self.appleImageView.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],

            [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:-30.0],
            [self.nameOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],

            [self.modelOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],
            [self.modelOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.deviceVersion.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:30.0],
            [self.deviceVersion.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],

            [self.secondLineView.leadingAnchor constraintEqualToAnchor:self.middle.leadingAnchor constant:50.0],
            [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor constant:-50.0],
            [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.secondLineView.heightAnchor constraintEqualToConstant:3.0],

            [self.middle.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.middle.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.middle.heightAnchor constraintEqualToConstant:self.view.frame.size.height/3.5],

            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.topAnchor constraintEqualToAnchor:self.middle.topAnchor],
            [self.middleStackView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],

            [self.firstLineView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:50.0],
            [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor constant:-50.0],
            [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.firstLineView.heightAnchor constraintEqualToConstant:3.0],

            [self.footer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            
            [self.openGitCVButton.topAnchor constraintEqualToAnchor:self.footer.topAnchor constant:20.0],
            [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.openGitCVButton.widthAnchor constraintEqualToConstant:300.0],
            [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],

            [self.goToStartButton.topAnchor constraintEqualToAnchor:self.openGitCVButton.bottomAnchor constant:20.0],
            [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.goToStartButton.widthAnchor constraintEqualToConstant:300.0],
            [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],
            
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.header.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.header.widthAnchor constraintEqualToConstant:self.view.frame.size.width/3],
                
            [self.nameOfDevice.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
            
            [self.appleImageView.heightAnchor constraintEqualToConstant:85.0],
            [self.appleImageView.widthAnchor constraintEqualToConstant:75.0],
            [self.appleImageView.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.appleImageView.bottomAnchor constraintEqualToAnchor:self.nameOfDevice.topAnchor constant:-10.0],

            
            [self.modelOfDevice.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.modelOfDevice.topAnchor constraintEqualToAnchor:self.nameOfDevice.bottomAnchor constant:10.0],
            
            [self.deviceVersion.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.deviceVersion.topAnchor constraintEqualToAnchor:self.modelOfDevice.bottomAnchor constant:10.0],

            [self.secondLineView.topAnchor constraintEqualToAnchor:self.middle.topAnchor constant:35.0],
            [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor constant:-70.0],
            [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor],
            [self.secondLineView.widthAnchor constraintEqualToConstant:3.0],

            [self.middle.leadingAnchor constraintEqualToAnchor:self.header.trailingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.middle.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.middle.widthAnchor constraintEqualToConstant:self.view.frame.size.width/2.8],

            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.centerYAnchor constraintEqualToAnchor:self.middle.centerYAnchor constant:-30.0],
//            [self.middleStackView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],

            [self.firstLineView.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:35.0],
            [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-70.0],
            [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor],
            [self.firstLineView.widthAnchor constraintEqualToConstant:3.0],

            [self.footer.leadingAnchor constraintEqualToAnchor:self.middle.trailingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                
            [self.openGitCVButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:-60.0],
            [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.openGitCVButton.widthAnchor constraintEqualToConstant:150.0],
            [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],

            [self.goToStartButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:30.0],
            [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.goToStartButton.widthAnchor constraintEqualToConstant:150.0],
            [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
        ]];
    }

}

- (void)setupFigures {
if (([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) && ((int)[[UIScreen mainScreen] nativeBounds].size.height <= 1335)) {

    // Setup TriangleView
    self.triangleView = [UIView new];
    self.triangleView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.triangleView.widthAnchor constraintEqualToConstant:kFiguresLittle],
        [self.triangleView.heightAnchor constraintEqualToConstant:kFiguresLittle]
    ]];
    // Draw Triangle
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(25.0, 0.0)];
    [trianglePath addLineToPoint:CGPointMake(kFiguresLittle, kFiguresLittle)];
    [trianglePath addLineToPoint:CGPointMake(0.0, kFiguresLittle)];
    [trianglePath closePath];

    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFiguresLittle, kFiguresLittle)];

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

    // Setup CircleView
    self.squareView = [UIView new];
    self.squareView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.squareView.widthAnchor constraintEqualToConstant:kFiguresLittle],
        [self.squareView.heightAnchor constraintEqualToConstant:kFiguresLittle]
    ]];
    // Draw Square
    UIBezierPath *squarePath = [UIBezierPath bezierPath];
    [squarePath moveToPoint:CGPointMake(0.0, 0.0)];
    [squarePath addLineToPoint:CGPointMake(kFiguresLittle, 0.0)];
    [squarePath addLineToPoint:CGPointMake(kFiguresLittle, kFiguresLittle)];
    [squarePath addLineToPoint:CGPointMake(0.0, kFiguresLittle)];
    [squarePath closePath];

    CAShapeLayer *squarePathMaskLayer = [CAShapeLayer layer];
    [squarePathMaskLayer setPath:squarePath.CGPath];

    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFiguresLittle, kFiguresLittle)];

    cView.backgroundColor = [UIColor ReqBlueColor];
    cView.layer.mask = squarePathMaskLayer;
    [self.squareView addSubview:cView];
        
    // Animate Square
    CABasicAnimation *positionAnimation;
    positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(25.0, 25.0 + 5)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(25.0, 25.0 - 5)];
    positionAnimation.duration = 1;
    positionAnimation.autoreverses = YES;
    positionAnimation.repeatCount = 100;
    positionAnimation.removedOnCompletion = NO;

    [cView.layer addAnimation:positionAnimation forKey:@"position"];

    // Setup CircleView
    self.circleView = [UIView new];
    self.circleView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.circleView.widthAnchor constraintEqualToConstant:kFiguresLittle],
        [self.circleView.heightAnchor constraintEqualToConstant:kFiguresLittle]
    ]];
    // Draw Circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kFiguresLittle, kFiguresLittle)] CGPath]];
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFiguresLittle, kFiguresLittle)];

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

} else {

    // Setup TriangleView
    self.triangleView = [UIView new];
    self.triangleView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.triangleView.widthAnchor constraintEqualToConstant:kFiguresNormal],
        [self.triangleView.heightAnchor constraintEqualToConstant:kFiguresNormal]
    ]];
    // Draw Triangle
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(35.0, 0.0)];
    [trianglePath addLineToPoint:CGPointMake(kFiguresNormal, kFiguresNormal)];
    [trianglePath addLineToPoint:CGPointMake(0.0, kFiguresNormal)];
    [trianglePath closePath];

    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFiguresNormal, kFiguresNormal)];

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

    // Setup CircleView
    self.squareView = [UIView new];
    self.squareView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.squareView.widthAnchor constraintEqualToConstant:kFiguresNormal],
        [self.squareView.heightAnchor constraintEqualToConstant:kFiguresNormal]
    ]];
    // Draw Square
    UIBezierPath *squarePath = [UIBezierPath bezierPath];
    [squarePath moveToPoint:CGPointMake(0.0, 0.0)];
    [squarePath addLineToPoint:CGPointMake(kFiguresNormal, 0.0)];
    [squarePath addLineToPoint:CGPointMake(kFiguresNormal, kFiguresNormal)];
    [squarePath addLineToPoint:CGPointMake(0.0, kFiguresNormal)];
    [squarePath closePath];

    CAShapeLayer *squarePathMaskLayer = [CAShapeLayer layer];
    [squarePathMaskLayer setPath:squarePath.CGPath];

    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFiguresNormal, kFiguresNormal)];

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
        [self.circleView.widthAnchor constraintEqualToConstant:kFiguresNormal],
        [self.circleView.heightAnchor constraintEqualToConstant:kFiguresNormal]
    ]];
    // Draw Circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kFiguresNormal, kFiguresNormal)] CGPath]];
    UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFiguresNormal, kFiguresNormal)];

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

}

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupViews];
}
   

#pragma mark - Handlers

- (void)openGitCV {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/alexTourGuide/rsschool-cv/blob/master/README.md"] options:@{} completionHandler:nil];
}

- (void)goToStart {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Helpers

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
