//
//  DismissSegue.m
//  libero
//
//  Created by Chiunti on 10/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue
- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
