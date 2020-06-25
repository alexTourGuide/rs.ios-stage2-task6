//
//  MediaTableViewCell.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/21/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "UIColor+RequiredColors.h"

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


- (void)configureWithMediaItem:(NSString *)mediaItem {
//    self.titleLable.text = mediaItem;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
