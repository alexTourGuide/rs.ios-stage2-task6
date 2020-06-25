//
//  ImageViewController.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/20/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "ImageViewController.h"
#import "UIColor+RequiredColors.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self setupView];
    self.modalPresentationCapturesStatusBarAppearance = YES;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)setupView {
//    self.view.frame = self.imageView.frame;
    UIImageView *imageView = [[UIImageView alloc] initWithImage: _image];
    
    [self.view addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [imageView.widthAnchor constraintEqualToConstant:self.view.frame.size.width - 30],
        [imageView.heightAnchor constraintEqualToConstant:(self.view.frame.size.width - 30) * _image.size.height / _image.size.width]
    ]];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
