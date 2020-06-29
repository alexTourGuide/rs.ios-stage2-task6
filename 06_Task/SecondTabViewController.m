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
#import "ShowAlertMessage.h"

@interface SecondTabViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic , strong) PHFetchResult *assetsFetchResults;
@property (nonatomic , strong) PHCachingImageManager *imageManager;

@end

@implementation SecondTabViewController

#pragma mark - Life cycle's methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    self.numberOfColumns = 3;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self fetchGalleryAndSort];    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
        }
    }];
}

#pragma mark - Setup views

- (void)setupCollectionView {
    self.view.backgroundColor = [UIColor requiredWhiteColor];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.backgroundColor = [UIColor requiredWhiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
    }

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:GalleryCollectionViewCell.class forCellWithReuseIdentifier:@"previewCellIdentifier"];
}

#pragma mark - CollectionView DataSours methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetsFetchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"previewCellIdentifier" forIndexPath:indexPath];
    [cell configureWithItem:_assetsFetchResults[indexPath.item]];
    return cell;
}

#pragma mark - CollectionView Delegate methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) ? (self.view.bounds.size.width - (15 * self.numberOfColumns)) / self.numberOfColumns : (self.view.bounds.size.width - (55 * self.numberOfColumns)) / self.numberOfColumns;
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)fetchGalleryAndSort {
    // Request for authorization
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
                break;
            case PHAuthorizationStatusDenied:
                [[ShowAlertMessage alloc] showLibraryAccessAlert:self title:@"Access to user's library" message:@"Authorization denied. Please go to app's settings to allow access"];
                break;
            case PHAuthorizationStatusRestricted:
                [[ShowAlertMessage alloc] showLibraryAccessAlert:self title:@"Access to user's library" message:@"Authorization restricted. Please go to app's settings to allow access"];
                break;
            default:
                break;
        }
    }];
    // Fetch all assets, sorted by date created.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO]];
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    self.imageManager = [PHCachingImageManager new];
}

- (void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.tabBarItem.title = @"Gallery";
    
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
    self.navigationController.topViewController.title = @"Gallery";
}

#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"Photo Library Did Change");

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
