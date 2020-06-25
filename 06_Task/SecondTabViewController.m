//
//  SecondTabViewController.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/20/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "SecondTabViewController.h"
#import "UIColor+RequiredColors.h"
#import "GalleryCollectionViewCell.h"
#import "ImageViewController.h"
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>

@interface SecondTabViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UIView *upperHeader;
@property (nonatomic, strong) UILabel *titleHeader;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) int numberOfColumns;

@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

@implementation SecondTabViewController

#pragma mark - Methods of View Controller's lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
        }
    }];
    [self fetchGalleryAndSort];
    self.numberOfColumns = 3;
    
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
    self.titleHeader.text = @"Gallery";
    self.titleHeader.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
    [self.upperHeader addSubview:self.titleHeader];
    self.titleHeader.translatesAutoresizingMaskIntoConstraints = NO;

    // Collection View
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.backgroundColor = [UIColor ReqWhiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Setup constraints
    [self setupConstraints];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:GalleryCollectionViewCell.class forCellWithReuseIdentifier:@"prevCellIdentifier"];
}

#pragma mark - CollectionView DataSours methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetsFetchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"prevCellIdentifier" forIndexPath:indexPath];
    
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setSynchronous:YES];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [_imageManager requestImageForAsset:asset
                             targetSize:cell.imageView.frame.size
                            contentMode:PHImageContentModeAspectFit
                                options:requestOptions
                          resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self photoAuthorizationWithCell:cell andResult:result andAsset:asset];
        });
    }];
    
    return cell;
}

#pragma mark - CollectionView Delegate methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        return UIEdgeInsetsMake(10, 50, 10, 10);
    } else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
        return UIEdgeInsetsMake(10, 10, 10, 50);
    } else {
    return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)) ? (self.view.bounds.size.width - (35 * self.numberOfColumns)) / self.numberOfColumns : (self.view.bounds.size.width - (15 * self.numberOfColumns)) / self.numberOfColumns;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    
    if ([asset mediaType] == PHAssetMediaTypeImage) {
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
    
    [self presentViewController:[[ImageViewController alloc] initWithImage:image] animated:YES completion:nil];
        
    } else if ([asset mediaType] == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *requestOptions = [PHVideoRequestOptions new];
        requestOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
        
        [_imageManager requestPlayerItemForVideo:asset options:requestOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                AVPlayerViewController *playerVC = [AVPlayerViewController new];
                playerVC.player = player;
                [self presentViewController:playerVC animated:YES completion:^{
                    [playerVC.player play];
                }];
            });
        }];
    }
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

            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.collectionView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    } else
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:90.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.bottomAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor constant:-18.0],

            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.collectionView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.upperHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.upperHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.upperHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.upperHeader.heightAnchor constraintEqualToConstant:50.0],

            [self.titleHeader.centerXAnchor constraintEqualToAnchor:self.upperHeader.centerXAnchor],
            [self.titleHeader.centerYAnchor constraintEqualToAnchor:self.upperHeader.centerYAnchor],

            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.collectionView.topAnchor constraintEqualToAnchor:self.upperHeader.bottomAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.collectionView updateConstraints];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)photoAuthorizationWithCell:(GalleryCollectionViewCell *)cell andResult:(UIImage *)image andAsset:(PHAsset *)asset {
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
                cell.imageView.image = [UIImage imageNamed:@"other"];
            } else {
                cell.imageView.image = image;
            }
        break;
        
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                        if ([asset mediaType] == PHAssetMediaTypeUnknown) {
                            cell.imageView.image = [UIImage imageNamed:@"other"];
                        } else {
                            cell.imageView.image = image;
                        }
                        break;
                    default:
                        break;
                }
            }];
        break;
    }
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

    dispatch_async(dispatch_get_main_queue(), ^{

        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        if (collectionChanges) {

            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];

            UICollectionView *collectionView = self.collectionView;
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
                    [collectionView reloadData];

                } else {
                    [collectionView performBatchUpdates:^{
                        if (removedPaths) {
                            [collectionView deleteItemsAtIndexPaths:removedPaths];
                        }

                        if (insertedPaths) {
                            [collectionView insertItemsAtIndexPaths:insertedPaths];
                        }

                        if (changedPaths) {
                            [collectionView reloadItemsAtIndexPaths:changedPaths];
                        }

                        if ([collectionChanges hasMoves]) {
                            [collectionChanges enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                                NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
                                NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
                                [collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                            }];
                        }

                    } completion:NULL];
                }

//                [self resetCachedAssets];
            } else {
                [collectionView reloadData];
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
