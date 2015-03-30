//
//  ClubNewViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "ClubNewViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Globals.h"


UIAlertView *alertError, *alertGuardar;
PFObject *currentObject;

@interface ClubNewViewController ()
{
    NSMutableArray *maDisciplina;
}

@end

@implementation ClubNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initController];
    
    // Connect data
    //self.pvDisciplina.dataSource = self;
    //self.pvDisciplina.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initController
{
    // llenar arreglo de disciplina
    
    PFQuery *query = [PFQuery queryWithClassName:@"disciplina"];
    maDisciplina = [NSMutableArray arrayWithArray:[query findObjects]];
    
    
    query = [PFQuery queryWithClassName:@"club"];
    //[query fromLocalDatastore];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    NSArray *arreglo = [query findObjects];
    
    // asignar nuevo o editar existente
    
    
    //if (arreglo.count == 0 )
    if (true )
    {
        currentObject = [PFObject objectWithClassName:@"club"];
        self.txtNombre.text      = @"";
        self.imgPhoto.image      = [[UIImage alloc] init];
    } else {
        currentObject = [arreglo objectAtIndex:0];
        //Leer datos del currentObject
        self.txtNombre.text      = currentObject[@"nombre"];
        PFFile *img = currentObject[@"imagen"];
        self.imgPhoto.image = [UIImage imageWithData:[img getData]];
    }
    
    
    
    self.vwAcquire.hidden = true;
    
    
    CGImageRef cgref = [self.imgPhoto.image CGImage];
    CIImage    *cim  = [self.imgPhoto.image CIImage];
    
    if (cim==nil&&cgref==NULL) {
        // Sin photo
        [self.btnPhoto setTitle: @"Foto" forState:UIControlStateNormal];
    } else {
        // registro existente
        [self.btnPhoto setTitle: @"" forState:UIControlStateNormal];
    }
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return maDisciplina.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [maDisciplina[row] objectForKey:@"nombre"] ;
}

// end picker view




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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}


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
    
    
    currentObject[@"nombre"] = self.txtNombre.text;
    currentObject[@"fbId"] = fbUser.objectID;
    
    
    NSData *imageData = UIImageJPEGRepresentation(self.imgPhoto.image, 0.8);
    PFFile *imageFile = [PFFile fileWithName:@"avatar.png" data:imageData];
    
    currentObject[@"imagen"] = imageFile;
    
    [self saveDataWithObject:currentObject];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Actualización completa" message:@"Usuario guardado" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
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
    self.vwAcquire.hidden = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)btnPhotoPressed:(id)sender {
    self.vwAcquire.hidden = NO;
}

- (IBAction)btnCloseAcquirePressed:(id)sender {
    self.vwAcquire.hidden = YES;
}

- (IBAction)btnLostFocusPressed:(id)sender {
    [[self view] endEditing:YES];
}

//called when the text field is being edited
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    sender.delegate = self;
}



@end
