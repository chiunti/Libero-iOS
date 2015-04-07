//
//  ProfileListViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "ProfileListViewController.h"

@interface ProfileListViewController ()

@end

@implementation ProfileListViewController

- (void)viewDidLoad {
    UIImage *background = [UIImage imageNamed: @"vb4.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [imageView setFrame:self.view.frame];
    
    [self.view insertSubview: imageView atIndex:0];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
