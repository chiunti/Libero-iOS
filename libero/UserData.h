//
//  UserData.h
//  libero
//
//  Created by Chiunti on 16/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserData : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


// Labels


// Image
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

// TextEdit
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtApellidoPat;
@property (weak, nonatomic) IBOutlet UITextField *txtApellidoMat;
@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;



// buttons
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;


// Views
@property (weak, nonatomic) IBOutlet UIView *vwAcquire;


// ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


// Actions
- (IBAction)btnSavePressed:(id)sender;
- (IBAction)btnLostFocusPressed:(id)sender;
- (IBAction)btnPhotoPressed:(id)sender;
- (IBAction)btnCloseAcquirePressed:(id)sender;
- (IBAction)btnCameraPressed:(id)sender;
- (IBAction)btnReelPressed:(id)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender;



@end
