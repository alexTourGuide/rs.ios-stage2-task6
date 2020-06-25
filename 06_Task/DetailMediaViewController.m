//
//  DetailMediaViewController.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/23/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "DetailMediaViewController.h"
#import "UIColor+RequiredColors.h"
#import "ActivityViewCustomActivity.h"

@interface DetailMediaViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *upperHeader;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleHeader;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *creatDateStr;
@property (nonatomic, strong) UILabel *creatDate;
@property (nonatomic, strong) UILabel *modDateStr;
@property (nonatomic, strong) UILabel *modDate;
@property (nonatomic, strong) UILabel *mediaNameStr;
@property (nonatomic, strong) UILabel *mediaName;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation DetailMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ReqWhiteColor];
    [self prefersStatusBarHidden];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupViews];
}


- (instancetype)initWithImage:(UIImage *)image withFilename:(NSString *)filename withCreationDate:(NSDate *)creationDate withModificationDate:(NSDate *)modificationDate withMediaType:(NSString *)mediaType {
    self = [super init];
    if (self) {
        _image = image;
        _filename = filename;
        _creationDate = creationDate;
        _modificationDate = modificationDate;
        _mediaType = mediaType;
    }
    return self;
}

- (void)setupViews {
    [self setupHeader];
    [self setupScrollView];
    [self setupInfo];
    [self setupButton];
    [self setupConstraints];
}

- (void)setupHeader {
    self.upperHeader = [UIView new];
    self.upperHeader.backgroundColor = [UIColor ReqYellowColor];
    [self.view addSubview:self.upperHeader];
    self.upperHeader.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Setup title
    self.titleHeader = [UILabel new];
    self.titleHeader.text = _filename;
    self.titleHeader.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
    [self.upperHeader addSubview:self.titleHeader];
    self.titleHeader.translatesAutoresizingMaskIntoConstraints = NO;

    // Setup backButton
    self.backButton = [UIButton new];
    self.backButton.tintColor = [UIColor ReqGrayColor];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.upperHeader addSubview:self.backButton];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupScrollView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 15.0, self.view.frame.size.width - 30, (self.view.frame.size.width - 30) * _image.size.height / _image.size.width)];
    self.imageView.image = _image;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.scrollView.backgroundColor = [UIColor ReqWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, ((self.view.frame.size.width - 30) * _image.size.height / _image.size.width) + self.creatDate.bounds.size.height + self.modDate.bounds.size.height + self.mediaName.bounds.size.height + self.shareButton.bounds.size.height + 250);
    [self.scrollView addSubview:self.imageView];
}

- (void)setupInfo {
    //Setup CreationDate String
    self.creatDateStr = [UILabel new];
    self.creatDateStr.text = @"Creation date:";
    self.creatDateStr.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.creatDateStr.textColor = [UIColor ReqGrayColor];
    self.creatDateStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.creatDateStr];

    //Setup CreationDate
    self.creatDate = [UILabel new];
    self.creatDate.text = [self dateToString:_creationDate];
    self.creatDate.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.creatDate.textColor = [UIColor ReqBlackColor];
    self.creatDate.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.creatDate];
    
    //Setup ModificationDate String
    self.modDateStr = [UILabel new];
    self.modDateStr.text = @"Modification date:";
    self.modDateStr.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.modDateStr.textColor = [UIColor ReqGrayColor];
    self.modDateStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.modDateStr];
    
    //Setup ModificationDate
    self.modDate = [UILabel new];
    self.modDate.text = [self dateToString:_modificationDate];
    self.modDate.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.modDate.textColor = [UIColor ReqBlackColor];
    self.modDate.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.modDate];
    
    //Setup MediaType String
    self.mediaNameStr = [UILabel new];
    self.mediaNameStr.text = @"Type:";
    self.mediaNameStr.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.mediaNameStr.textColor = [UIColor ReqGrayColor];
    self.mediaNameStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.mediaNameStr];
    
    //Setup MediaType
    self.mediaName = [UILabel new];
    self.mediaName.text = _mediaType;
    self.mediaName.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.mediaName.textColor = [UIColor ReqBlackColor];
    self.mediaName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.mediaName];
}

- (void)setupButton {
    // Setup Share Button
    self.shareButton = [UIButton new];
    self.shareButton.backgroundColor = [UIColor ReqYellowColor];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    [self.shareButton setTitleColor:[UIColor ReqBlackColor] forState:UIControlStateNormal];
    self.shareButton.layer.cornerRadius = 55.0 / 2;
    
    [self.scrollView addSubview:self.shareButton];
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Helpers

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterFullStyle;
    formatter.dateFormat = @"HH:mm:ss dd.MM.yyyy";
    return [formatter stringFromDate:date];
}

- (void)setupConstraints {
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) && ((int)[[UIScreen mainScreen] nativeBounds].size.height <= 1335)) {
    [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],

            [self.backButton.leadingAnchor constraintEqualToAnchor:self.upperHeader.leadingAnchor constant:20.0],
            [self.backButton.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],

            [self.scrollView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

            [self.creatDateStr.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:15.0],
            [self.creatDateStr.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:30.0],

            [self.creatDate.centerYAnchor constraintEqualToAnchor:self.creatDateStr.centerYAnchor],
            [self.creatDate.leadingAnchor constraintEqualToAnchor:self.creatDateStr.trailingAnchor constant:3.0],

            [self.modDateStr.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:15.0],
            [self.modDateStr.topAnchor constraintEqualToAnchor:self.creatDateStr.bottomAnchor constant:15.0],

            [self.modDate.centerYAnchor constraintEqualToAnchor:self.modDateStr.centerYAnchor],
            [self.modDate.leadingAnchor constraintEqualToAnchor:self.modDateStr.trailingAnchor constant:3.0],

            [self.mediaNameStr.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:15.0],
            [self.mediaNameStr.topAnchor constraintEqualToAnchor:self.modDateStr.bottomAnchor constant:15.0],

            [self.mediaName.centerYAnchor constraintEqualToAnchor:self.mediaNameStr.centerYAnchor],
            [self.mediaName.leadingAnchor constraintEqualToAnchor:self.mediaNameStr.trailingAnchor constant:3.0],

            [self.shareButton.topAnchor constraintEqualToAnchor:self.mediaName.bottomAnchor constant:30.0],
            [self.shareButton.heightAnchor constraintEqualToConstant:55.0],
            [self.shareButton.widthAnchor constraintEqualToConstant:300.0],
            [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]

    ]];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:90.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.bottomAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor constant:-18.0],

            [self.backButton.leadingAnchor constraintEqualToAnchor:self.upperHeader.leadingAnchor constant:20.0],
            [self.backButton.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],

            [self.scrollView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

            [self.creatDateStr.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:15.0],
            [self.creatDateStr.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:30.0],

            [self.creatDate.centerYAnchor constraintEqualToAnchor:self.creatDateStr.centerYAnchor],
            [self.creatDate.leadingAnchor constraintEqualToAnchor:self.creatDateStr.trailingAnchor constant:3.0],

            [self.modDateStr.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:15.0],
            [self.modDateStr.topAnchor constraintEqualToAnchor:self.creatDateStr.bottomAnchor constant:15.0],

            [self.modDate.centerYAnchor constraintEqualToAnchor:self.modDateStr.centerYAnchor],
            [self.modDate.leadingAnchor constraintEqualToAnchor:self.modDateStr.trailingAnchor constant:3.0],

            [self.mediaNameStr.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:15.0],
            [self.mediaNameStr.topAnchor constraintEqualToAnchor:self.modDateStr.bottomAnchor constant:15.0],

            [self.mediaName.centerYAnchor constraintEqualToAnchor:self.mediaNameStr.centerYAnchor],
            [self.mediaName.leadingAnchor constraintEqualToAnchor:self.mediaNameStr.trailingAnchor constant:3.0],

            [self.shareButton.topAnchor constraintEqualToAnchor:self.mediaName.bottomAnchor constant:30.0],
            [self.shareButton.heightAnchor constraintEqualToConstant:55.0],
            [self.shareButton.widthAnchor constraintEqualToConstant:300.0],
            [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]

    ]];
    } else if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)) {
                [NSLayoutConstraint activateConstraints:@[
                    [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                    [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                    [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                    [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],
        
                    [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
                    [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],
        
                    [self.backButton.leadingAnchor constraintEqualToAnchor:self.upperHeader.leadingAnchor constant:20.0],
                    [self.backButton.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],
        
                    [self.scrollView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
                    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:40.0],
                    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-40.0],
                    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
                    [self.creatDateStr.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5.0],
                    [self.creatDateStr.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:30.0],
        
                    [self.creatDate.centerYAnchor constraintEqualToAnchor:self.creatDateStr.centerYAnchor],
                    [self.creatDate.leadingAnchor constraintEqualToAnchor:self.creatDateStr.trailingAnchor constant:3.0],
        
                    [self.modDateStr.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5.0],
                    [self.modDateStr.topAnchor constraintEqualToAnchor:self.creatDateStr.bottomAnchor constant:15.0],
        
                    [self.modDate.centerYAnchor constraintEqualToAnchor:self.modDateStr.centerYAnchor],
                    [self.modDate.leadingAnchor constraintEqualToAnchor:self.modDateStr.trailingAnchor constant:3.0],
        
                    [self.mediaNameStr.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5.0],
                    [self.mediaNameStr.topAnchor constraintEqualToAnchor:self.modDateStr.bottomAnchor constant:15.0],
        
                    [self.mediaName.centerYAnchor constraintEqualToAnchor:self.mediaNameStr.centerYAnchor],
                    [self.mediaName.leadingAnchor constraintEqualToAnchor:self.mediaNameStr.trailingAnchor constant:3.0],
        
                    [self.shareButton.topAnchor constraintEqualToAnchor:self.mediaName.bottomAnchor constant:30.0],
                    [self.shareButton.heightAnchor constraintEqualToConstant:55.0],
                    [self.shareButton.widthAnchor constraintEqualToConstant:300.0],
                    [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                ]];
            } else {
                [NSLayoutConstraint activateConstraints:@[
                    [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                    [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                    [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                    [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],
        
                    [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
                    [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],
        
                    [self.backButton.leadingAnchor constraintEqualToAnchor:self.upperHeader.leadingAnchor constant:20.0],
                    [self.backButton.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],
        
                    [self.scrollView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
                    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
                    [self.creatDateStr.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5.0],
                    [self.creatDateStr.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:30.0],
        
                    [self.creatDate.centerYAnchor constraintEqualToAnchor:self.creatDateStr.centerYAnchor],
                    [self.creatDate.leadingAnchor constraintEqualToAnchor:self.creatDateStr.trailingAnchor constant:3.0],
        
                    [self.modDateStr.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5.0],
                    [self.modDateStr.topAnchor constraintEqualToAnchor:self.creatDateStr.bottomAnchor constant:15.0],
        
                    [self.modDate.centerYAnchor constraintEqualToAnchor:self.modDateStr.centerYAnchor],
                    [self.modDate.leadingAnchor constraintEqualToAnchor:self.modDateStr.trailingAnchor constant:3.0],
        
                    [self.mediaNameStr.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:5.0],
                    [self.mediaNameStr.topAnchor constraintEqualToAnchor:self.modDateStr.bottomAnchor constant:15.0],
        
                    [self.mediaName.centerYAnchor constraintEqualToAnchor:self.mediaNameStr.centerYAnchor],
                    [self.mediaName.leadingAnchor constraintEqualToAnchor:self.mediaNameStr.trailingAnchor constant:3.0],
        
                    [self.shareButton.topAnchor constraintEqualToAnchor:self.mediaName.bottomAnchor constant:30.0],
                    [self.shareButton.heightAnchor constraintEqualToConstant:55.0],
                    [self.shareButton.widthAnchor constraintEqualToConstant:300.0],
                    [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                ]];
        
            }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self setupViews];
}

#pragma mark - Handlers

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, (self.view.frame.size.width - 30) * _image.size.height / _image.size.width)];

    UIImage *image = _image;
    ActivityViewCustomActivity *aVCA = [ActivityViewCustomActivity new];
    NSArray* sharedObjects = [NSArray arrayWithObjects:image,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:@[aVCA]];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
