//
//  ShowAlertMessage.m
//  06_Task
//
//  Created by Alexander Porshnev on 6/29/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import "ShowAlertMessage.h"

@implementation ShowAlertMessage

- (void)showLibraryAccessAlert:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                          actionWithTitle:@"OK"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          { }];

    [alert addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alert animated:YES completion:nil];
    });

}

@end
