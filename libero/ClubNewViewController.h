//
//  ClubNewViewController.h
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubNewViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UIPickerView *pvDisciplina;
@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *vwAcquire;
- (IBAction)btnLostFocusPressed:(id)sender;
- (IBAction)btnPhotoPressed:(id)sender;
- (IBAction)btnCloseAcquirePressed:(id)sender;
- (IBAction)btnCameraPressed:(id)sender;
- (IBAction)btnReelPressed:(id)sender;
- (IBAction)btnSavePressed:(id)sender;
- (IBAction)textFieldDidBeginEditing:(id)sender;

@end
