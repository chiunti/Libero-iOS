//
//  HomeViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "HomeViewController.h"
#import "Globals.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    firstrunning = false;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.profilePictureView.profileID = fbUser.objectID;
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
