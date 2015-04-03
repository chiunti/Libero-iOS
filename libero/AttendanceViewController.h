//
//  AttendanceViewController.h
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *dpFecha;
- (IBAction)dpFechaChanged:(id)sender;

@end
