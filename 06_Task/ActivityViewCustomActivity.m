//
//  ActivityViewCustomActivity.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/23/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "ActivityViewCustomActivity.h"

@implementation ActivityViewCustomActivity

- (NSString *)activityType {
    return @"RSSchool. Task 6";
}

- (NSString *)activityTitle {
    return @"Share Media";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"apple"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController {
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity {
    // This is where you can do anything you want, and is the whole reason for creating a custom UIActivity
    [self activityDidFinish:YES];
}

@end
