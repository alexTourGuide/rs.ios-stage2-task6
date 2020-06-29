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
#import <Photos/Photos.h>

@interface DetailMediaViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *creatDateStr;
@property (nonatomic, strong) UILabel *creatDate;
@property (nonatomic, strong) UILabel *modDateStr;
@property (nonatomic, strong) UILabel *modDate;
@property (nonatomic, strong) UILabel *mediaNameStr;
@property (nonatomic, strong) UILabel *mediaName;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, assign) CGFloat multiplier;

@property (strong, nonatomic) NSArray<NSLayoutConstraint *>* portraitConstraintsCollection;
@property (strong, nonatomic) NSArray<NSLayoutConstraint *>* landscapeConstraintsCollection;
@property (nonatomic) UIInterfaceOrientation lastOrientation;

@end

@implementation DetailMediaViewController

- (instancetype)initWithMediaItem:(PHAsset *)mediaItem {
    self = [super init];
    if (self) {
        _mediaItem = mediaItem;
    }
    return self;
}


#pragma mark - Life cycle's methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.view.backgroundColor = [UIColor requiredWhiteColor];
    [self extractDataFromAsset];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setUpViewConstraintsForInterfaceOrientation:self.lastOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
}

#pragma mark - Setup views

- (void)setupViews {
    [self setupScrollView];
    [self setupInfo];
    [self setupButton];
    [self setupConstraints];
}

#pragma mark - Handlers

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, (self.view.frame.size.width - 30) * self.imageView.image.size.height / self.imageView.image.size.width)];
    
    ActivityViewCustomActivity *aVCA = [ActivityViewCustomActivity new];
    NSArray* sharedObjects = [NSArray arrayWithObjects:self.imageView.image,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:@[aVCA]];
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Helpers

- (void)extractDataFromAsset {
    self.imageView = [UIImageView new];
    PHAsset *asset = _mediaItem;
    if (([asset mediaType] == PHAssetMediaTypeImage) || ([asset mediaType] == PHAssetMediaTypeVideo)) {
        PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
        [requestOptions setResizeMode:PHImageRequestOptionsResizeModeExact];
        [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
        [requestOptions setSynchronous:YES];
    
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.height)
                                              contentMode:PHImageContentModeAspectFit
                                                  options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = result;
            });
        }];
        
    } else if ([asset mediaType] == PHAssetMediaTypeImage) {
        self.imageView.image = [UIImage imageNamed:@"audio"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"other"];
    }

}

- (void)setupScrollView {
    // Calculate a multiplier
    NSUInteger pixelHeight = self.mediaItem.pixelHeight;
    CGFloat pixelHeightFloat = (CGFloat)pixelHeight;
    NSUInteger pixelWidth = self.mediaItem.pixelWidth;
    CGFloat pixelWidthFloat = (CGFloat)pixelWidth;
    self.multiplier = pixelHeightFloat / pixelWidthFloat;
    // Setup scrollView
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.scrollView.backgroundColor = [UIColor requiredWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, ((self.view.bounds.size.width - 30) * self.multiplier) + self.creatDate.bounds.size.height + self.modDate.bounds.size.height + self.mediaName.bounds.size.height + self.shareButton.bounds.size.height + 250);
    [self.scrollView addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupInfo {
    //Setup CreationDate String
    self.creatDateStr = [UILabel new];
    self.creatDateStr.text = @"Creation date:";
    self.creatDateStr.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.creatDateStr.textColor = [UIColor requiredGrayColor];
    self.creatDateStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.creatDateStr];

    //Setup CreationDate
    self.creatDate = [UILabel new];
    self.creatDate.text = [self dateToString:self.mediaItem.creationDate];
    self.creatDate.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.creatDate.textColor = [UIColor requiredBlackColor];
    self.creatDate.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.creatDate];
    
    //Setup ModificationDate String
    self.modDateStr = [UILabel new];
    self.modDateStr.text = @"Modification date:";
    self.modDateStr.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.modDateStr.textColor = [UIColor requiredGrayColor];
    self.modDateStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.modDateStr];
    
    //Setup ModificationDate
    self.modDate = [UILabel new];
    self.modDate.text = [self dateToString:self.mediaItem.modificationDate];
    self.modDate.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.modDate.textColor = [UIColor requiredBlackColor];
    self.modDate.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.modDate];
    
    //Setup MediaType String
    self.mediaNameStr = [UILabel new];
    self.mediaNameStr.text = @"Type:";
    self.mediaNameStr.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.mediaNameStr.textColor = [UIColor requiredGrayColor];
    self.mediaNameStr.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.mediaNameStr];
    
    //Setup MediaType
    self.mediaName = [UILabel new];
    switch ([self.mediaItem mediaType]) {
        case PHAssetMediaTypeImage:
            self.mediaName.text = @"Image";
            break;
        case PHAssetMediaTypeVideo:
            self.mediaName.text = @"Video";
            break;
        case PHAssetMediaTypeAudio:
            self.mediaName.text = @"Audio";
            break;
        case PHAssetMediaTypeUnknown:
            self.mediaName.text = @"Unknown";
            break;
        }
    self.mediaName.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    self.mediaName.textColor = [UIColor requiredBlackColor];
    self.mediaName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.mediaName];
}

- (void)setupButton {
    // Setup Share Button
    self.shareButton = [UIButton new];
    self.shareButton.backgroundColor = [UIColor requiredYellowColor];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    [self.shareButton setTitleColor:[UIColor requiredBlackColor] forState:UIControlStateNormal];
    self.shareButton.layer.cornerRadius = 55.0 / 2;
    
    [self.scrollView addSubview:self.shareButton];
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    if (@available(iOS 11.0, *)) {
        self.portraitConstraintsCollection = @[
            [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            
            [self.imageView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.95],
            [self.imageView.heightAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:self.multiplier],
            [self.imageView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10.0],
            [self.imageView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor],

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
            [self.shareButton.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.8],
            [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
        ];
        self.landscapeConstraintsCollection = @[
            [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            
            [self.imageView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.95],
            [self.imageView.heightAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:self.multiplier],
            [self.imageView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10.0],
            [self.imageView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor],
            
            [self.creatDateStr.trailingAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:5.0],
            [self.creatDateStr.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:30.0],
            
            [self.creatDate.centerYAnchor constraintEqualToAnchor:self.creatDateStr.centerYAnchor],
            [self.creatDate.leadingAnchor constraintEqualToAnchor:self.creatDateStr.trailingAnchor constant:3.0],
            
            [self.modDateStr.trailingAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:5.0],
            [self.modDateStr.topAnchor constraintEqualToAnchor:self.creatDateStr.bottomAnchor constant:15.0],
            
            [self.modDate.centerYAnchor constraintEqualToAnchor:self.modDateStr.centerYAnchor],
            [self.modDate.leadingAnchor constraintEqualToAnchor:self.modDateStr.trailingAnchor constant:3.0],
            
            [self.mediaNameStr.trailingAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:5.0],
            [self.mediaNameStr.topAnchor constraintEqualToAnchor:self.modDateStr.bottomAnchor constant:15.0],
            
            [self.mediaName.centerYAnchor constraintEqualToAnchor:self.mediaNameStr.centerYAnchor],
            [self.mediaName.leadingAnchor constraintEqualToAnchor:self.mediaNameStr.trailingAnchor constant:3.0],
            
            [self.shareButton.topAnchor constraintEqualToAnchor:self.mediaName.bottomAnchor constant:30.0],
            [self.shareButton.heightAnchor constraintEqualToConstant:55.0],
            [self.shareButton.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.4],
            [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
        ];
    } else {
        self.portraitConstraintsCollection = @[
            [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            
            [self.imageView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.95],
            [self.imageView.heightAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:self.multiplier],
            [self.imageView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10.0],
            [self.imageView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor],

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
            [self.shareButton.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.8],
            [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
        ];
        self.landscapeConstraintsCollection = @[
            [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            
            [self.imageView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.95],
            [self.imageView.heightAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:self.multiplier],
            [self.imageView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10.0],
            [self.imageView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor],
            
            [self.creatDateStr.trailingAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:5.0],
            [self.creatDateStr.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:30.0],
            
            [self.creatDate.centerYAnchor constraintEqualToAnchor:self.creatDateStr.centerYAnchor],
            [self.creatDate.leadingAnchor constraintEqualToAnchor:self.creatDateStr.trailingAnchor constant:3.0],
            
            [self.modDateStr.trailingAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:5.0],
            [self.modDateStr.topAnchor constraintEqualToAnchor:self.creatDateStr.bottomAnchor constant:15.0],
            
            [self.modDate.centerYAnchor constraintEqualToAnchor:self.modDateStr.centerYAnchor],
            [self.modDate.leadingAnchor constraintEqualToAnchor:self.modDateStr.trailingAnchor constant:3.0],
            
            [self.mediaNameStr.trailingAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:5.0],
            [self.mediaNameStr.topAnchor constraintEqualToAnchor:self.modDateStr.bottomAnchor constant:15.0],
            
            [self.mediaName.centerYAnchor constraintEqualToAnchor:self.mediaNameStr.centerYAnchor],
            [self.mediaName.leadingAnchor constraintEqualToAnchor:self.mediaNameStr.trailingAnchor constant:3.0],
            
            [self.shareButton.topAnchor constraintEqualToAnchor:self.mediaName.bottomAnchor constant:30.0],
            [self.shareButton.heightAnchor constraintEqualToConstant:55.0],
            [self.shareButton.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:0.4],
            [self.shareButton.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
        ];
    }
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterFullStyle;
    formatter.dateFormat = @"HH:mm:ss dd.MM.yyyy";
    return [formatter stringFromDate:date];
}

- (void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    
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
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.topViewController.title = [self.mediaItem valueForKey:@"filename"];
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
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, ((self.view.bounds.size.width - 30) * self.multiplier) + self.creatDate.bounds.size.height + self.modDate.bounds.size.height + self.mediaName.bounds.size.height + self.shareButton.bounds.size.height + 150);
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    [self updateViewConstraints];
    [self.view setNeedsDisplay];
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
