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
#import <Photos/Photos.h>
#import "DetailMediaViewController.h"
#import "ShowAlertMessage.h"

@interface FirstViewController () <UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

@implementation FirstViewController

#pragma mark - Life cycle's methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchGalleryAndSort];
    [self setupNavigationBar];
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
    self.navigationItem.title = @"Info";
    self.view.backgroundColor = [UIColor requiredWhiteColor];
   // Setup Table View
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
            [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
    }
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
    [cell configureWithMediaItem:_assetsFetchResults[indexPath.item]];

    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor requiredYellowHighlightedColor];
    [cell setSelectedBackgroundView:selectedView];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[DetailMediaViewController alloc] initWithMediaItem:_assetsFetchResults[indexPath.item]] animated:YES];
}

#pragma mark - Helpers

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self updateViewConstraints];
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
                [[ShowAlertMessage alloc] showLibraryAccessAlert:self title:@"Access to user's library" message:@"PAuthorization restricted. Please go to app's settings to allow access"];
                break;
            default:
                break;
        }
    }];
    
    // Fetch all assets, sorted by date created.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO]];
    _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];

    _imageManager = [[PHCachingImageManager alloc] init];
}

- (void)setupNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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
    self.navigationController.topViewController.title = @"Info";
}

#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
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
