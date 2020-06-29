//
//  ShowAlertMessage.h
//  06_Task
//
//  Created by Alexander Porshnev on 6/29/20.
//  Copyright © 2020 Alexander Porshnev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowAlertMessage : NSObject

- (void)showLibraryAccessAlert:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
