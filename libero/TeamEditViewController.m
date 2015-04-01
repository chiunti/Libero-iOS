//
//  TeamEditViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "TeamEditViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Globals.h"

@interface TeamEditViewController ()
{
    NSMutableArray *maClub;
}
@end

@implementation TeamEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initController
{
    // llenar arreglo de disciplina
    
    PFQuery *query = [PFQuery queryWithClassName:@"club"];
    maClub = [NSMutableArray arrayWithArray:[query findObjects]];
    
    
    if (currentTeam == nil )
    {
        // datos nuevos
        currentTeam = [PFObject objectWithClassName:@"equipo"];
        self.txtNombre.text      = @"";
        
        self.stepCategoria.value = [[[NSCalendar currentCalendar]
                                     components:NSCalendarUnitYear fromDate:[NSDate date]]
                                    year];
        [self stepCategoriaChanged:nil];
    } else {
        //Leer datos del currentObject
        // editando
        self.txtNombre.text      = currentTeam[@"nombre"];
        
        ;
        /*
        [maClub indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            PFObject *club = (PFObject) obj;
            return [[club objectForKey:@"nombre"] isEqualToString:self.
        }];
        */
        NSString *xrama = currentTeam[@"rama"];
        [self.pvClub selectRow:[maClub indexOfObject:currentTeam[@"club"]] inComponent:0 animated:YES];
        for (NSInteger i = 0; i< [self.selRama numberOfSegments]; i++) {
            NSString *titulo = [self.selRama titleForSegmentAtIndex:i];
            if ( [titulo isEqualToString:xrama]) {
                [self.selRama setSelectedSegmentIndex:i];
            }
        }
        for (NSInteger i = 0; i< [self.selDivision numberOfSegments]; i++) {
            if ([[self.selDivision titleForSegmentAtIndex:i] isEqualToString:currentTeam[@"division"]]) {
                [self.selDivision setSelectedSegmentIndex:i];
            }
        }
        self.txtAnio.text = currentTeam[@"categoria"];
        //[self.swCategoria setOn:[currentTeam[@"categoria"] rangeOfString:@"-"].location >0];
        NSRange pos =[currentTeam[@"categoria"] rangeOfString:@"-"];
        [self.swCategoria setOn: pos.location != NSNotFound ];
        NSString *valor = [currentTeam[@"categoria"] componentsSeparatedByString:@"-"][0];
        self.stepCategoria.value = [valor doubleValue];
    }
    
   /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    */
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
    return maClub.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [maClub[row] objectForKey:@"nombre"] ;
}

// end picker view
/*
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
*/

- (IBAction)btnSavePressed:(id)sender {
    BOOL showAlert = false;

    // Fields required
    //txtNombre
    if ([self.txtNombre.text length]==0) {
        showAlert = true;
        self.txtNombre.layer.borderWidth = 1;
        self.txtNombre.layer.borderColor = [[UIColor redColor] CGColor];
    } else {
        self.txtNombre.layer.borderWidth = 0;
    }
    
    //txtAnio
    if ([self.txtAnio.text length]==0) {
        showAlert = true;
        self.txtAnio.layer.borderWidth = 1;
        self.txtAnio.layer.borderColor = [[UIColor redColor] CGColor];
    } else {
        self.txtAnio.layer.borderWidth = 0;
    }
    
    
    
    if (showAlert) {
        [alertError show];
        return;
    }
    
    
    currentTeam[@"nombre"] = self.txtNombre.text;
    currentTeam[@"club"] = maClub [[self.pvClub  selectedRowInComponent:0]];
    currentTeam[@"rama"] = [self.selRama titleForSegmentAtIndex:self.selRama.selectedSegmentIndex];
    currentTeam[@"division"] = [self.selDivision titleForSegmentAtIndex:self.selDivision.selectedSegmentIndex];
    currentTeam[@"categoria"] = self.txtAnio.text;
    
    currentTeam[@"fbId"] = fbUser.objectID;
    
    
    [self saveDataWithObject:currentTeam];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Actualización completa" message:@"Equipo guardado" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getTeams" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fallo la actualización" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
}

- (IBAction)btnLostFocusPressed:(id)sender {
    [[self view] endEditing:YES];
}

//called when the text field is being edited
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    sender.delegate = self;
}


- (IBAction)selRamaChanged:(id)sender {
}

- (IBAction)selDivisionChanged:(id)sender {
}

- (IBAction)swCategoriaChanged:(id)sender {
    [self stepCategoriaChanged:nil];
}

- (IBAction)stepCategoriaChanged:(id)sender {
    
    if (self.swCategoria.isOn) {
        self.txtAnio.text = [NSString stringWithFormat:@"%i-%i", (int)self.stepCategoria.value,(int)self.stepCategoria.value+1];
    } else {
        self.txtAnio.text = [NSString stringWithFormat:@"%i", (int)self.stepCategoria.value];
    }
}



@end
