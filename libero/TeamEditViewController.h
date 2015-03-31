//
//  TeamEditViewController.h
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamEditViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPickerView *pvClub;
@property (strong, nonatomic) IBOutlet UITextField *txtNombre;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selRama;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selDivision;
@property (strong, nonatomic) IBOutlet UITextField *txtAnio;
@property (strong, nonatomic) IBOutlet UISwitch *swCategoria;
@property (strong, nonatomic) IBOutlet UIStepper *stepCategoria;
- (IBAction)btnLostFocusPressed:(id)sender;
- (IBAction)selRamaChanged:(id)sender;
- (IBAction)selDivisionChanged:(id)sender;
- (IBAction)swCategoriaChanged:(id)sender;
- (IBAction)stepCategoriaChanged:(id)sender;
- (IBAction)textFieldDidBeginEditing:(id)sender;
- (IBAction)btnSavePressed:(id)sender;

@end
