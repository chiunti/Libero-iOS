//
//  DocumentEditViewController.h
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentEditViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtDocumento;
- (IBAction)btnSavePressed:(id)sender;
- (IBAction)btnLostFocusPressed:(id)sender;

@end
