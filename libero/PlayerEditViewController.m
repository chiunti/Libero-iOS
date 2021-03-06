//
//  PlayerEditViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "PlayerEditViewController.h"
#import <Parse/Parse.h>
#import "Globals.h"
#import "MBProgressHUD.h"

PFQuery *query;
UIButton *backgroundView;
NSMutableArray *maClub;
NSMutableArray *maEquipo;
NSMutableArray *maPerfil;

@interface PlayerEditViewController ()

@end

@implementation PlayerEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self initController];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initController
{
    
    query = [PFQuery queryWithClassName:@"club"];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    maClub = [NSMutableArray arrayWithArray:[query findObjects]];

    query = [PFQuery queryWithClassName:@"equipo"];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    maEquipo = [NSMutableArray arrayWithArray:[query findObjects]];
    
    query = [PFQuery queryWithClassName:@"perfil"];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    maPerfil = [NSMutableArray arrayWithArray:[query findObjects]];
    
    if (currentPlayer == nil ){
        // jugador nuevo
        currentPlayer = [PFObject objectWithClassName:@"jugador"];
        self.txtNombre.text      = @"";
        self.txtTelefono.text    = @"";
        self.txtEmail.text       = @"";
        self.txtCalzado.text     = @"";
        self.txtDomicilio.text   = @"";
        self.txtNumero.text      = @"";
        self.imgPhoto.image      = [[UIImage alloc] init];


    } else {
        // jugador existente
        //Leer datos del currentObject
        self.txtNombre.text      = currentPlayer[@"nombre"];
        self.txtTelefono.text    = currentPlayer[@"telefono"];
        self.txtEmail.text       = currentPlayer[@"email"];
        self.txtCalzado.text     = currentPlayer[@"calzado"];
        self.txtDomicilio.text   = currentPlayer[@"domicilio"];
        self.txtNumero.text      = currentPlayer[@"numero"];
        
        for (NSInteger i = 0; i< [self.selPlayera numberOfSegments]; i++) {
            if ([[self.selPlayera titleForSegmentAtIndex:i] isEqualToString:currentPlayer[@"playera"]]) {
                [self.selPlayera setSelectedSegmentIndex:i];
            }
        }
        
        [self.pvClubCategoPerfil selectRow:[maEquipo indexOfObject:currentPlayer[@"equipo"]] inComponent:0 animated:NO];

        [self.pvClubCategoPerfil selectRow:[maPerfil indexOfObject:currentPlayer[@"perfil"]] inComponent:1 animated:NO];
        
        self.stepNumero.value = [self.txtNumero.text doubleValue];
        self.stepCalzado.value = [self.txtCalzado.text doubleValue];
        

        PFFile *img = currentPlayer[@"imagen"];
        self.imgPhoto.image = [UIImage imageWithData:[img getData]];
    }
    self.lblPerfil.text = [maPerfil[0] objectForKey:@"nombre"];

    
    
    // config view for photo
    [self.vwAcquire removeFromSuperview];
    self.vwAcquire.frame = CGRectMake((self.view.frame.size.width-200)/2, -200, 200 , 200);
    
    if (backgroundView == nil)
    {
        backgroundView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,
                          [UIScreen mainScreen].bounds.size.width,
                          [UIScreen mainScreen].bounds.size.height)
                          ];
    }
    backgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f];
    [backgroundView addTarget:self
                       action:@selector(btnCloseAcquirePressed:)
             forControlEvents:UIControlEventTouchUpInside];
    self.vwAcquire.layer.cornerRadius = 8;

    
    
    CGImageRef cgref = [self.imgPhoto.image CGImage];
    CIImage    *cim  = [self.imgPhoto.image CIImage];
    
    if (cim==nil&&cgref==NULL) {
        // Sin photo
        [self.btnPhoto setTitle: @"Foto" forState:UIControlStateNormal];
    } else {
        // registro existente
        [self.btnPhoto setTitle: @"" forState:UIControlStateNormal];
    }
    
    
    
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    alertError = [[UIAlertView alloc] initWithTitle:@"Corregir"
                                            message:@"Verifique que todos los campos tengan datos"
                                           delegate:self
                                  cancelButtonTitle:@"Aceptar"
                                  otherButtonTitles:nil];
    alertGuardar = [[UIAlertView alloc] initWithTitle:@"Datos guardados"
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
//called when the text field is being edited
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    sender.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

///picker view
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return maEquipo.count;
    } else if (component == 1){
        return maPerfil.count;
    } else {
        return 0;
    }
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        PFObject *club = [maEquipo[row] objectForKey:@"club"];
        [club fetch];
        return  [NSString stringWithFormat:@"%@ - %@", [club objectForKey:@"nombre"], [maEquipo[row] objectForKey:@"nombre"]];
    } else if (component == 1){
        return [maPerfil[row] objectForKey:@"nombre"];
    } else {
        return @"";
    }
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    UILabel *label = [[UILabel alloc] init];
    //label.backgroundColor = [UIColor lightGrayColor];
    //label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"System" size:14];
    //label.text = [NSString stringWithFormat:@"  %d", (int)row+1];
    if (component == 0) {
        PFObject *club = [maEquipo[row] objectForKey:@"club"];
        [club fetch];
        label.text = [NSString stringWithFormat:@"%@ - %@", [club objectForKey:@"nombre"], [maEquipo[row] objectForKey:@"nombre"]];
        label.textAlignment = NSTextAlignmentLeft;
    } else if (component == 1){
        label.text = [maPerfil[row] objectForKey:@"nombre"];
        label.textAlignment = NSTextAlignmentRight;
    } else {
        label.text = @"";
    }
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==1){
        self.lblPerfil.text = [maPerfil[row] objectForKey:@"nombre"];
    }
}

// end picker view


- (IBAction)btnSavePressed:(id)sender {
    BOOL showAlert = false;
    CGImageRef cgref = [self.imgPhoto.image CGImage];
    CIImage    *cim  = [self.imgPhoto.image CIImage];
    
    if (cim==nil&&cgref==NULL) {
        self.btnPhoto.layer.borderColor = [[UIColor redColor] CGColor];
        showAlert = true;
    } else {
        self.btnPhoto.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    
    // Fields required
    //txtNombre
    if ([self.txtNombre.text length]==0) {
        showAlert = true;
        self.txtNombre.layer.borderWidth = 1;
        self.txtNombre.layer.borderColor = [[UIColor redColor] CGColor];
    } else {
        self.txtNombre.layer.borderWidth = 0;
    }
    
    
    if (showAlert) {
        [alertError show];
        return;
    }
    
    
    currentPlayer[@"nombre"] = self.txtNombre.text;
    currentPlayer[@"telefono"] = self.txtTelefono.text;
    currentPlayer[@"domicilio"] = self.txtDomicilio.text;
    currentPlayer[@"email"] = self.txtEmail.text;
    currentPlayer[@"playera"] = [self.selPlayera titleForSegmentAtIndex:self.selPlayera.selectedSegmentIndex];
    currentPlayer[@"numero"] = self.txtNumero.text;
    currentPlayer[@"calzado"] = self.txtCalzado.text;
    currentPlayer[@"equipo"] = maEquipo [[self.pvClubCategoPerfil  selectedRowInComponent:0]];
    currentPlayer[@"perfil"] = maPerfil [[self.pvClubCategoPerfil  selectedRowInComponent:1]];
    
    
    
    currentPlayer[@"fbId"] = fbUser.objectID;
    
    
    NSData *imageData = UIImageJPEGRepresentation(self.imgPhoto.image, 0.8);
    PFFile *imageFile = [PFFile fileWithName:@"avatar.png" data:imageData];
    
    currentPlayer[@"imagen"] = imageFile;
    
    [self saveDataWithObject:currentPlayer];
}


-(void)saveDataWithObject:(PFObject *)testObject
{
    
    //[testObject saveInBackground];
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Actualizando";
    [hud show:YES];
    
    // Upload recipe to Parse
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Actualización completa" message:@"Jugador guardado" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPlayers" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fallo la actualización" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
}

- (IBAction)btnCameraPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)btnReelPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imgPhoto.image = chosenImage;
    [self.btnPhoto setTitle: @"" forState:UIControlStateNormal];
    //self.vwAcquire.hidden = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self btnCloseAcquirePressed:self];
    [self.vwAcquire removeFromSuperview];
    [backgroundView removeFromSuperview];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)btnPhotoPressed:(id)sender {
    
    //self.vwAcquire.hidden = NO;

    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.vwAcquire.frame = CGRectMake((self.view.frame.size.width-200)/2, 20, 200, 200);
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:backgroundView];
    [self.view addSubview:self.vwAcquire];
    
    
}

- (IBAction)btnCloseAcquirePressed:(id)sender {
    //self.vwAcquire.hidden = YES;
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.vwAcquire.frame = CGRectMake((self.view.frame.size.width-200)/2, -200, 200 , 200);
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [self.vwAcquire removeFromSuperview];
                             [backgroundView removeFromSuperview];
                         }
                     }];
}

- (IBAction)btnLostFocusPressed:(id)sender {
    [[self view] endEditing:YES];
}




- (IBAction)stepNumeroChanged:(id)sender {
    self.txtNumero.text = [NSString  stringWithFormat:@"%i", (int)self.stepNumero.value ];
}

- (IBAction)stepCalzadoChanged:(id)sender {
    self.txtCalzado.text = [NSString  stringWithFormat:@"%i", (int)self.stepCalzado.value ];
}


@end
