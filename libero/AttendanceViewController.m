//
//  AttendanceViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "AttendanceViewController.h"
#import "Globals.h"

@interface AttendanceViewController ()

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dpFecha.datePickerMode = UIDatePickerModeDate;
    currentFecha = [self.dpFecha date];

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

- (IBAction)dpFechaChanged:(id)sender {
    
    currentFecha = [self.dpFecha date];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewDate" object:self];

}
@end
