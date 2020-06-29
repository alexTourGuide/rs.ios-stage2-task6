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
#import "UIView+Figures.h"

@interface ThirdViewController ()

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *middle;
@property (nonatomic, strong) UIView *footer;
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

@property (strong, nonatomic) NSArray<NSLayoutConstraint *>* portraitConstraintsCollection;
@property (strong, nonatomic) NSArray<NSLayoutConstraint *>* landscapeConstraintsCollection;
@property (nonatomic) UIInterfaceOrientation lastOrientation;

@end

@implementation ThirdViewController

#pragma mark - Life cycle's methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.view.backgroundColor = [UIColor requiredWhiteColor];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setUpViewConstraintsForInterfaceOrientation:self.lastOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self startFiguresAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopFiguresAnimations];
}

#pragma mark - Setup views

- (void)setupViews {
    [self setupContainers];
    [self setupPhoneInfo];
    [self setupFigures];
    [self setupButtons];
    [self setupConstraints];
}

#pragma mark - Handlers

- (void)openGitCV {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/alexTourGuide/rsschool-cv/blob/master/README.md"] options:@{} completionHandler:nil];
}

- (void)goToStart {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Helpers

- (void)setupContainers {
    self.header = [UIView new];
    self.header.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.header];
    self.header.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.middle = [UIView new];
    self.middle.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.middle];
    self.middle.translatesAutoresizingMaskIntoConstraints = NO;

    self.middleStackView = [UIStackView new];
    self.middleStackView.axis = (([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) && ((int)[[UIScreen mainScreen] nativeBounds].size.height <= 1335)) ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    self.middleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.middleStackView.alignment = UIStackViewAlignmentCenter;
    self.middleStackView.spacing = 20.0;
    
    [self.middle addSubview:self.middleStackView];
    self.middleStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.footer = [UIView new];
    self.footer.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.footer];
    self.footer.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupPhoneInfo {
    self.appleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple"]];
    [self.header addSubview:self.appleImageView];
    self.appleImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.nameOfDevice = [UILabel new];
    self.nameOfDevice.text = [UIDevice currentDevice].name;
    self.nameOfDevice.numberOfLines = 0;
    self.nameOfDevice.textAlignment = NSTextAlignmentCenter;
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
    self.firstLineView.backgroundColor = [UIColor requiredGrayColor];
    [self.header addSubview:self.firstLineView];
    self.firstLineView.translatesAutoresizingMaskIntoConstraints = NO;
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
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(122, 35.0 + 7)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(122, 35.0 - 7)];
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

- (void)setupButtons {
    self.secondLineView = [UIView new];
    self.secondLineView.backgroundColor = [UIColor requiredGrayColor];
    [self.middle addSubview:self.secondLineView];
    self.secondLineView.translatesAutoresizingMaskIntoConstraints = NO;

    self.openGitCVButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openGitCVButton.backgroundColor = [UIColor requiredYellowColor];
    [self.openGitCVButton setTitle:@"Open Git CV" forState:UIControlStateNormal];
    self.openGitCVButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.openGitCVButton setTitleColor:[UIColor requiredBlackColor] forState:UIControlStateNormal];
    self.openGitCVButton.layer.cornerRadius = 55.0 / 2;
    [self.footer addSubview:self.openGitCVButton];
    self.openGitCVButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.openGitCVButton addTarget:self action:@selector(openGitCV) forControlEvents:UIControlEventTouchUpInside];

    self.goToStartButton = [[UIButton alloc] init];
    self.goToStartButton.backgroundColor = [UIColor requiredRedColor];
    [self.goToStartButton setTitle:@"Go to start" forState:UIControlStateNormal];
    self.goToStartButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.goToStartButton setTitleColor:[UIColor requiredWhiteColor] forState:UIControlStateNormal];
    self.goToStartButton.layer.cornerRadius = 55.0 / 2;
    [self.footer addSubview:self.goToStartButton];
    self.goToStartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.goToStartButton addTarget:self action:@selector(goToStart) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    if (@available(iOS 11.0, *)) {
        self.portraitConstraintsCollection = @[
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.header.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.header.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.333],
            
            [self.appleImageView.heightAnchor constraintEqualToAnchor:self.header.heightAnchor multiplier:0.45],
            [self.appleImageView.widthAnchor constraintEqualToAnchor:self.header.heightAnchor multiplier:0.4],
            [self.appleImageView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:50.0],
            [self.appleImageView.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],
            
            [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:-30.0],
            [self.nameOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.modelOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],
            [self.modelOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.deviceVersion.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:30.0],
            [self.deviceVersion.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.firstLineView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:50.0],
            [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor constant:-50.0],
            [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.firstLineView.heightAnchor constraintEqualToConstant:3.0],
            
            [self.middle.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.middle.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.middle.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.333],
            
            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.centerYAnchor constraintEqualToAnchor:self.middle.centerYAnchor],
            
            [self.secondLineView.leadingAnchor constraintEqualToAnchor:self.middle.leadingAnchor constant:50.0],
            [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor constant:-50.0],
            [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.secondLineView.heightAnchor constraintEqualToConstant:3.0],
            
            [self.footer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            
            [self.openGitCVButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:-35.0],
            [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.openGitCVButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],
            
            [self.goToStartButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:35.0],
            [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.goToStartButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
        ];
        self.landscapeConstraintsCollection = @[
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.header.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            [self.header.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.333],
                        
            [self.nameOfDevice.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:20.0],
                    
            [self.appleImageView.heightAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:0.4],
            [self.appleImageView.widthAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:0.35],
            [self.appleImageView.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.appleImageView.bottomAnchor constraintEqualToAnchor:self.nameOfDevice.topAnchor constant:-10.0],
                    
            [self.modelOfDevice.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.modelOfDevice.topAnchor constraintEqualToAnchor:self.nameOfDevice.bottomAnchor constant:10.0],
                    
            [self.deviceVersion.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.deviceVersion.topAnchor constraintEqualToAnchor:self.modelOfDevice.bottomAnchor constant:10.0],

            [self.firstLineView.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:35.0],
            [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-35.0],
            [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor],
            [self.firstLineView.widthAnchor constraintEqualToConstant:3.0],

            [self.middle.leadingAnchor constraintEqualToAnchor:self.header.trailingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.middle.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            [self.middle.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.4],

            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.centerYAnchor constraintEqualToAnchor:self.middle.centerYAnchor],
            
            [self.secondLineView.topAnchor constraintEqualToAnchor:self.middle.topAnchor constant:35.0],
            [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor constant:-35.0],
            [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor],
            [self.secondLineView.widthAnchor constraintEqualToConstant:3.0],

            [self.footer.leadingAnchor constraintEqualToAnchor:self.middle.trailingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                        
            [self.openGitCVButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:-35.0],
            [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.openGitCVButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],

            [self.goToStartButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:35.0],
            [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.goToStartButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
        ];
    } else {
        self.portraitConstraintsCollection = @[
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.header.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.333],
            
            [self.appleImageView.heightAnchor constraintEqualToAnchor:self.header.heightAnchor multiplier:0.45],
            [self.appleImageView.widthAnchor constraintEqualToAnchor:self.header.heightAnchor multiplier:0.4],
            [self.appleImageView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:30.0],
            [self.appleImageView.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor constant:15.0],
            
            [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.appleImageView.centerYAnchor constant:-30.0],
            [self.nameOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.modelOfDevice.centerYAnchor constraintEqualToAnchor:self.appleImageView.centerYAnchor],
            [self.modelOfDevice.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.deviceVersion.centerYAnchor constraintEqualToAnchor:self.appleImageView.centerYAnchor constant:30.0],
            [self.deviceVersion.leadingAnchor constraintEqualToAnchor:self.appleImageView.trailingAnchor constant:15.0],
            
            [self.firstLineView.leadingAnchor constraintEqualToAnchor:self.header.leadingAnchor constant:40.0],
            [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor constant:-40.0],
            [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.firstLineView.heightAnchor constraintEqualToConstant:3.0],
            
            [self.middle.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.header.bottomAnchor],
            [self.middle.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.middle.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.3],
            
            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.centerYAnchor constraintEqualToAnchor:self.middle.centerYAnchor],
            
            [self.secondLineView.leadingAnchor constraintEqualToAnchor:self.middle.leadingAnchor constant:40.0],
            [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor constant:-40.0],
            [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.secondLineView.heightAnchor constraintEqualToConstant:3.0],
            
            [self.footer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.middle.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            
            [self.openGitCVButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:-55.0],
            [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.openGitCVButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],
            
            [self.goToStartButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:15.0],
            [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.goToStartButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
        ];
        self.landscapeConstraintsCollection = @[
            [self.header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.header.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.header.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.25],
                        
            [self.nameOfDevice.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.nameOfDevice.centerYAnchor constraintEqualToAnchor:self.header.centerYAnchor],
            [self.nameOfDevice.widthAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:0.9],
                    
            [self.appleImageView.heightAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:0.55],
            [self.appleImageView.widthAnchor constraintEqualToAnchor:self.header.widthAnchor multiplier:0.5],
            [self.appleImageView.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.appleImageView.bottomAnchor constraintEqualToAnchor:self.nameOfDevice.topAnchor constant:-10.0],
                    
            [self.modelOfDevice.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.modelOfDevice.topAnchor constraintEqualToAnchor:self.nameOfDevice.bottomAnchor constant:10.0],
                    
            [self.deviceVersion.centerXAnchor constraintEqualToAnchor:self.header.centerXAnchor],
            [self.deviceVersion.topAnchor constraintEqualToAnchor:self.modelOfDevice.bottomAnchor constant:10.0],

            [self.firstLineView.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:35.0],
            [self.firstLineView.bottomAnchor constraintEqualToAnchor:self.header.bottomAnchor constant:-35.0],
            [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.header.trailingAnchor],
            [self.firstLineView.widthAnchor constraintEqualToConstant:3.0],

            [self.middle.leadingAnchor constraintEqualToAnchor:self.header.trailingAnchor],
            [self.middle.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.middle.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.middle.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.45],

            [self.middleStackView.centerXAnchor constraintEqualToAnchor:self.middle.centerXAnchor],
            [self.middleStackView.centerYAnchor constraintEqualToAnchor:self.middle.centerYAnchor],
            
            [self.secondLineView.topAnchor constraintEqualToAnchor:self.middle.topAnchor constant:35.0],
            [self.secondLineView.bottomAnchor constraintEqualToAnchor:self.middle.bottomAnchor constant:-35.0],
            [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.middle.trailingAnchor],
            [self.secondLineView.widthAnchor constraintEqualToConstant:3.0],

            [self.footer.leadingAnchor constraintEqualToAnchor:self.middle.trailingAnchor],
            [self.footer.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.footer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.footer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                        
            [self.openGitCVButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:-35.0],
            [self.openGitCVButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.openGitCVButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.openGitCVButton.heightAnchor constraintEqualToConstant:55.0],

            [self.goToStartButton.centerYAnchor constraintEqualToAnchor:self.footer.centerYAnchor constant:35.0],
            [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.footer.centerXAnchor],
            [self.goToStartButton.widthAnchor constraintEqualToAnchor:self.footer.widthAnchor multiplier:0.8],
            [self.goToStartButton.heightAnchor constraintEqualToConstant:55.0]
        ];
    }
}

- (void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (@available(iOS 13, *)) {
        [self.navigationController navigationBar].standardAppearance = [UINavigationBarAppearance new];
        [[self.navigationController navigationBar].standardAppearance configureWithDefaultBackground];
        
        [self.navigationController navigationBar].standardAppearance.backgroundColor = [UIColor requiredYellowColor];
        [self.navigationController navigationBar].standardAppearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor requiredBlackColor],
            NSFontAttributeName:[UIFont systemFontOfSize:18.0
                                                  weight:UIFontWeightSemibold]};
    }
    else {
        [self.navigationController navigationBar].barTintColor = [UIColor requiredYellowColor];
        [self.navigationController navigationBar].titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor requiredBlackColor],
            NSFontAttributeName:[UIFont systemFontOfSize:18.0
                                                  weight:UIFontWeightSemibold]
        };
    }
    self.navigationController.topViewController.title = @"RSSchool Task 6";
}

- (void)setUpViewConstraintsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        self.lastOrientation = interfaceOrientation;
        if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
            [NSLayoutConstraint deactivateConstraints:self.portraitConstraintsCollection];
            [NSLayoutConstraint activateConstraints:self.landscapeConstraintsCollection];
        } else if (interfaceOrientation == UIInterfaceOrientationPortrait){
            [NSLayoutConstraint deactivateConstraints:self.landscapeConstraintsCollection];
            [NSLayoutConstraint activateConstraints:self.portraitConstraintsCollection];
        }
        [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (size.height < size.width && ((self.lastOrientation != UIInterfaceOrientationLandscapeLeft) || (self.lastOrientation != UIInterfaceOrientationLandscapeRight))) {
        [self setUpViewConstraintsForInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    } else if (size.height >= size.width && self.lastOrientation != UIInterfaceOrientationPortrait){
        [self setUpViewConstraintsForInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

@end
