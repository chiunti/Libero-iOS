//
//  ViewController.h
//  libero
//
//  Created by Chiunti on 09/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <FBLoginViewDelegate,UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView2;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnConfig;
@property (strong, nonatomic) IBOutlet UIButton *btnSalir;
@property (strong, nonatomic) IBOutlet UIButton *btnToMain;

- (IBAction)loginPressed:(id)sender;
- (IBAction)btnToMainPressed:(id)sender;

@end

