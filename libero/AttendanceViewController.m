//
//  AttendanceViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "AttendanceViewController.h"
#import "Globals.h"
#import "CLWeeklyCalendarView.h"

@interface AttendanceViewController ()

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    UIImage *background = [UIImage imageNamed: @"vb3.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [imageView setFrame:self.view.frame];
    
    [self.view insertSubview: imageView atIndex:0];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 120)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @1,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    
    currentFecha = date;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewDate" object:self];

}


@end
