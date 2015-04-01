//
//  PlayerEditViewController.h
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerEditViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (strong, nonatomic) IBOutlet UIPickerView *pvClubCategoPerfil;
@property (strong, nonatomic) IBOutlet UILabel *lblPerfil;
@property (strong, nonatomic) IBOutlet UITextField *txtTelefono;
@property (strong, nonatomic) IBOutlet UITextField *txtDomicilio;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selPlayera;
@property (strong, nonatomic) IBOutlet UITextField *txtNumero;
@property (strong, nonatomic) IBOutlet UITextField *txtCalzado;
@property (strong, nonatomic) IBOutlet UIView *vwAcquire;
@property (strong, nonatomic) IBOutlet UIStepper *stepNumero;
@property (strong, nonatomic) IBOutlet UIStepper *stepCalzado;

- (IBAction)btnLostFocusPressed:(id)sender;
- (IBAction)btnPhotoPressed:(id)sender;
- (IBAction)stepNumeroChanged:(id)sender;
- (IBAction)stepCalzadoChanged:(id)sender;

- (IBAction)btnCloseAcquirePressed:(id)sender;
- (IBAction)btnCameraPressed:(id)sender;
- (IBAction)btnReelPressed:(id)sender;
- (IBAction)btnSavePressed:(id)sender;

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender;

@end
