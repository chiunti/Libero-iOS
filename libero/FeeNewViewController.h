//
//  FeeNewViewController.h
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeNewViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtConcepto;
@property (strong, nonatomic) IBOutlet UITextField *txtImporte;
- (IBAction)btnSavePressed:(id)sender;

@end
