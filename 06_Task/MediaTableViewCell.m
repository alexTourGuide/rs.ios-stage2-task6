//
//  MediaTableViewCell.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/21/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "UIColor+RequiredColors.h"
#import <Photos/Photos.h>

@interface MediaTableViewCell ()


@end

@implementation MediaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor requiredYellowHighlightedColor];
    self.selectedBackgroundView = backgroundView;
}

- (void)setupViews {
    // previewImage
    self.previewView = [UIImageView new];
    [self addSubview:self.previewView];
    self.previewView.translatesAutoresizingMaskIntoConstraints = NO;

    // Title
    self.titleLable = [UILabel new];
    self.titleLable.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
    [self addSubview:self.titleLable];
    self.titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    
    // IconMedia
    self.iconMedia = [UIImageView new];
    [self addSubview:self.iconMedia];
    self.iconMedia.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Detail info
    self.detailInfo = [UILabel new];
    self.detailInfo.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
    [self addSubview:self.detailInfo];
    self.detailInfo.translatesAutoresizingMaskIntoConstraints = NO;

    [self setupConstraints];
}

- (void)setupConstraints {
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
    [NSLayoutConstraint activateConstraints:@[
        [self.previewView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:50.0],
        [self.previewView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.0],
        [self.previewView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.0],
        [self.previewView.widthAnchor constraintEqualToAnchor:self.previewView.heightAnchor multiplier:1.0],

        [self.titleLable.leadingAnchor constraintEqualToAnchor:self.previewView.trailingAnchor constant:10.0],
        [self.titleLable.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-10.0],

        [self.iconMedia.leadingAnchor constraintEqualToAnchor:self.previewView.trailingAnchor constant:10.0],
        [self.iconMedia.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:15.0],

        [self.detailInfo.leadingAnchor constraintEqualToAnchor:self.iconMedia.trailingAnchor constant:6.0],
        [self.detailInfo.centerYAnchor constraintEqualToAnchor:self.iconMedia.centerYAnchor],
    ]];
    } else {
       [NSLayoutConstraint activateConstraints:@[
        [self.previewView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5.0],
        [self.previewView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.0],
        [self.previewView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.0],
        [self.previewView.widthAnchor constraintEqualToAnchor:self.previewView.heightAnchor multiplier:1.0],

        [self.titleLable.leadingAnchor constraintEqualToAnchor:self.previewView.trailingAnchor constant:10.0],
        [self.titleLable.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-10.0],

        [self.iconMedia.leadingAnchor constraintEqualToAnchor:self.previewView.trailingAnchor constant:10.0],
        [self.iconMedia.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:15.0],

        [self.detailInfo.leadingAnchor constraintEqualToAnchor:self.iconMedia.trailingAnchor constant:6.0],
        [self.detailInfo.centerYAnchor constraintEqualToAnchor:self.iconMedia.centerYAnchor],
      ]];
    }
}


- (void)configureWithMediaItem:(PHAsset *)mediaItem {
        PHAsset *asset = mediaItem;
        PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
        [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
        [[PHImageManager defaultManager] requestImageForAsset:asset
                              targetSize:self.previewView.frame.size
                             contentMode:PHImageContentModeAspectFit
                                 options:requestOptions
                           resultHandler:^(UIImage *result, NSDictionary *info) {
         dispatch_async(dispatch_get_main_queue(), ^(void){
             [self photoAuthorizationWithResult:result andAsset:asset];
             self.titleLable.text = [asset valueForKey:@"filename"];
             if ([asset mediaType] == PHAssetMediaTypeImage) {
                 self.iconMedia.image = [UIImage imageNamed:@"image"];
                 self.detailInfo.text = [NSString stringWithFormat:@"%@x%@", [asset valueForKey:@"pixelWidth"], [asset valueForKey:@"pixelHeight"]];
             } else if ([asset mediaType] == PHAssetMediaTypeAudio) {
                 self.iconMedia.image = [UIImage imageNamed:@"audio"];
                 self.detailInfo.text = [NSString stringWithFormat:@"%@", [self getDurationWithFormat:asset.duration]];
             } else if ([asset mediaType] == PHAssetMediaTypeVideo) {
                 self.iconMedia.image = [UIImage imageNamed:@"video"];
                 self.detailInfo.text = [NSString stringWithFormat:@"%@x%@ %@", [asset valueForKey:@"pixelWidth"], [asset valueForKey:@"pixelHeight"], [self getDurationWithFormat:asset.duration]];
             } else {
                 self.iconMedia.image = [UIImage imageNamed:@"other"];
             }
         });
     }];
}

- (void)photoAuthorizationWithResult:(UIImage *)image andAsset:(PHAsset *)asset {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusRestricted:
            NSLog(@"Photo Auth restricted");
            break;
        
        case PHAuthorizationStatusDenied:
        NSLog(@"Photo Auth denied");
        break;
            
        case PHAuthorizationStatusAuthorized:
            if ([asset mediaType] == PHAssetMediaTypeUnknown) {
                self.previewView.image = [UIImage imageNamed:@"other"];
            } else if ([asset mediaType] == PHAssetMediaTypeAudio) {
                self.previewView.image = [UIImage imageNamed:@"audio"];
            } else {
                self.previewView.image = image;
            }
        break;
        
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        if ([asset mediaType] == PHAssetMediaTypeUnknown) {
                            self.previewView.image = [UIImage imageNamed:@"other"];
                        } else if ([asset mediaType] == PHAssetMediaTypeAudio) {
                            self.previewView.image = [UIImage imageNamed:@"audio"];
                        } else {
                            self.previewView.image = image;
                        }
                        break;
                    default:
                        break;
                }
            }];
        break;
    }
}

- (NSString*)getDurationWithFormat:(NSTimeInterval)duration {
    NSInteger ti = (NSInteger)duration;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

@end
