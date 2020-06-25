//
//  FirstViewController.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/20/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "FirstViewController.h"
#import "UIColor+RequiredColors.h"
#import "MediaTableViewCell.h"
#import "MediaItem.h"
#import <Photos/Photos.h>
#import "DetailMediaViewController.h"

@interface FirstViewController () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UIView *upperHeader;
@property (nonatomic, strong) UILabel *titleHeader;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

@implementation FirstViewController

#pragma mark - Methods of View Controller's lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
        }
    }];
    [self fetchGalleryAndSort];
    [self setupViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
        }
    }];
}
#pragma mark - Setup views

- (void)setupViews {
    // Setup upperHeader
    self.upperHeader = [UIView new];
    self.upperHeader.backgroundColor = [UIColor ReqYellowColor];
    [self.view addSubview:self.upperHeader];
    self.upperHeader.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Setup title
    self.titleHeader = [UILabel new];
    self.titleHeader.text = @"Info";
    self.titleHeader.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
    [self.upperHeader addSubview:self.titleHeader];
    self.titleHeader.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Setup Table View
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // Setup constraints
    [self setupConstraints];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:MediaTableViewCell.class forCellReuseIdentifier:@"Cell"];
}

#pragma mark - TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetsFetchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

 
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
   
    [_imageManager requestImageForAsset:asset
                             targetSize:cell.previewView.frame.size
                            contentMode:PHImageContentModeAspectFit
                                options:requestOptions
                          resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self photoAuthorizationWithCell:cell andResult:result andAsset:asset];
            cell.titleLable.text = [asset valueForKey:@"filename"];
            if ([asset mediaType] == PHAssetMediaTypeImage) {
                cell.iconMedia.image = [UIImage imageNamed:@"image"];
                cell.detailInfo.text = [NSString stringWithFormat:@"%@x%@", [asset valueForKey:@"pixelWidth"], [asset valueForKey:@"pixelHeight"]];
            } else if ([asset mediaType] == PHAssetMediaTypeAudio) {
                cell.iconMedia.image = [UIImage imageNamed:@"audio"];
                cell.detailInfo.text = [NSString stringWithFormat:@"%@", [self getDurationWithFormat:asset.duration]];
            } else if ([asset mediaType] == PHAssetMediaTypeVideo) {
                cell.iconMedia.image = [UIImage imageNamed:@"video"];
                cell.detailInfo.text = [NSString stringWithFormat:@"%@x%@ %@", [asset valueForKey:@"pixelWidth"], [asset valueForKey:@"pixelHeight"], [self getDurationWithFormat:asset.duration]];
            } else {
                cell.iconMedia.image = [UIImage imageNamed:@"other"];
            }
        });
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor ReqYellowHighlightedColor];
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor ReqYellowHighlightedColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor ReqYellowHighlightedColor];
    
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    
    CGFloat retinaMultiplier = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.view.bounds.size.width * retinaMultiplier, asset.pixelWidth / asset.pixelHeight * retinaMultiplier);
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setSynchronous:YES];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    __block UIImage *image;
    
    [_imageManager requestImageForAsset:asset
                             targetSize:size
                            contentMode:PHImageContentModeAspectFill
                                options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    
    NSString *filename = [asset valueForKey:@"filename"];
    NSString *mediaType;
    switch ([asset mediaType]) {
        case PHAssetMediaTypeImage:
            mediaType = @"Image";
            break;
        case PHAssetMediaTypeVideo:
            mediaType = @"Video";
            break;
        case PHAssetMediaTypeAudio:
            mediaType = @"Audio";
        break;
        case PHAssetMediaTypeUnknown:
            mediaType = @"Unknown";
        break;
    }
    
    [self.navigationController pushViewController:[[DetailMediaViewController alloc] initWithImage:image withFilename:filename withCreationDate:asset.creationDate withModificationDate:asset.modificationDate withMediaType:mediaType] animated:YES];
}

#pragma mark - Helpers

- (void)setupConstraints {
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) && ((int)[[UIScreen mainScreen] nativeBounds].size.height <= 1335)) {
        [NSLayoutConstraint activateConstraints:@[
                [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],

                [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
                [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],

                [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [self.tableView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
                [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:90.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.bottomAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor constant:-18.0],

            [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.tableView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],

            [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.tableView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self setupViews];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)photoAuthorizationWithCell:(MediaTableViewCell *)cell andResult:(UIImage *)image andAsset:(PHAsset *)asset {
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
                cell.previewView.image = [UIImage imageNamed:@"other"];
            } else if ([asset mediaType] == PHAssetMediaTypeAudio) {
                cell.previewView.image = [UIImage imageNamed:@"audio"];
            } else {
                cell.previewView.image = image;
            }
        break;
        
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        if ([asset mediaType] == PHAssetMediaTypeUnknown) {
                            cell.previewView.image = [UIImage imageNamed:@"other"];
                        } else if ([asset mediaType] == PHAssetMediaTypeAudio) {
                            cell.previewView.image = [UIImage imageNamed:@"audio"];
                        } else {
                            cell.previewView.image = image;
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

- (void)fetchGalleryAndSort {
    // Fetch all assets, sorted by date created.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO]];
    _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];

    _imageManager = [[PHCachingImageManager alloc] init];
}


#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"Here");

    dispatch_async(dispatch_get_main_queue(), ^{

        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        if (collectionChanges) {

            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];

            UITableView *tableView = self.tableView;
            NSArray *removedPaths;
            NSArray *insertedPaths;
            NSArray *changedPaths;

            if ([collectionChanges hasIncrementalChanges]) {
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                removedPaths = [self indexPathsFromIndexSet:removedIndexes withSection:0];

                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                insertedPaths = [self indexPathsFromIndexSet:insertedIndexes withSection:0];

                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                changedPaths = [self indexPathsFromIndexSet:changedIndexes withSection:0];

                BOOL shouldReload = NO;

                if (changedPaths != nil && removedPaths != nil) {
                    for (NSIndexPath *changedPath in changedPaths) {
                        if ([removedPaths containsObject:changedPath]) {
                            shouldReload = YES;
                            break;
                        }
                    }
                }

                if (removedPaths.lastObject && ((NSIndexPath *)removedPaths.lastObject).item >= self.assetsFetchResults.count) {
                    shouldReload = YES;
                }

                if (shouldReload) {
                    [tableView reloadData];

                } else {
                    if (@available(iOS 11.0, *)) {
                        [tableView performBatchUpdates:^{
                            if (removedPaths) {
                                [self.tableView deleteRowsAtIndexPaths:removedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if (insertedPaths) {
                                [self.tableView insertRowsAtIndexPaths:insertedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if (changedPaths) {
                                [self.tableView reloadRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if ([collectionChanges hasMoves]) {
                                [collectionChanges enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                                    NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
                                    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
                                    [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                                }];
                            }
                            
                        } completion:NULL];
                    } else {
                            if (removedPaths) {
                                [self.tableView deleteRowsAtIndexPaths:removedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if (insertedPaths) {
                                [self.tableView insertRowsAtIndexPaths:insertedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if (changedPaths) {
                                [self.tableView reloadRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if ([collectionChanges hasMoves]) {
                                [collectionChanges enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                                    NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
                                    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
                                    [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                                }];
                            }
                           
                    }
                }

//                [self resetCachedAssets];
            } else {
                [tableView reloadData];
            }
        }
    });
}

- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet withSection:(int)section {
    if (indexSet == nil) {
        return nil;
    }
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];

    return indexPaths;
}

@end
