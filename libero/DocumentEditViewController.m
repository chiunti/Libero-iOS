//
//  DocumentEditViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "DocumentEditViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Globals.h"

@interface DocumentEditViewController ()

@end

@implementation DocumentEditViewController

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
    
    
    if (currentDocument == nil )
    {
        // datos nuevos
        currentDocument = [PFObject objectWithClassName:@"documento"];
        self.txtDocumento.text      = @"";
        
    } else {
        //Leer datos del currentObject
        // editando
        self.txtDocumento.text      = currentDocument[@"nombre"];
        
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
- (IBAction)btnSavePressed:(id)sender {
    BOOL showAlert = false;
    
    // Fields required
    //txtNombre
    if ([self.txtDocumento.text length]==0) {
        showAlert = true;
        self.txtDocumento.layer.borderWidth = 1;
        self.txtDocumento.layer.borderColor = [[UIColor redColor] CGColor];
    } else {
        self.txtDocumento.layer.borderWidth = 0;
    }
    
    
    if (showAlert) {
        [alertError show];
        return;
    }
    
    
    currentDocument[@"nombre"] = self.txtDocumento.text;
    
    currentDocument[@"fbId"] = fbUser.objectID;
    
    
    [self saveDataWithObject:currentDocument];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Actualización completa" message:@"Documento guardado" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getDocuments" object:self];
            
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

@end
