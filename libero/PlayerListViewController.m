//
//  PlayerListViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "PlayerListViewController.h"

@interface PlayerListViewController ()

@end

@implementation PlayerListViewController

- (void)viewDidLoad {
    UIImage *background = [UIImage imageNamed: @"vb_blur.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    
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
