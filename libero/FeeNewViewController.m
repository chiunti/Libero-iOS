//
//  FeeNewViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "FeeNewViewController.h"
#import <Parse/Parse.h>
#import "Globals.h"
#import "MBProgressHUD.h"

@interface FeeNewViewController ()

@end

@implementation FeeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initController];

}

-(void)initController
{
    
    if (currentQuota == nil ){
        // jugador nuevo
        currentQuota = [PFObject objectWithClassName:@"cuota"];
        self.txtConcepto.text      = @"";
        self.txtImporte.text       = @"";
        
    } else {
        // jugador existente
        //Leer datos del currentObject
        self.txtConcepto.text      = currentQuota[@"nombre"];
        self.txtImporte.text       = currentQuota[@"importe"];
    }
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([self.txtConcepto.text length]==0) {
        showAlert = true;
        self.txtConcepto.layer.borderWidth = 1;
        self.txtConcepto.layer.borderColor = [[UIColor redColor] CGColor];
    } else {
        self.txtConcepto.layer.borderWidth = 0;
    }
    
    
    if (showAlert) {
        [alertError show];
        return;
    }
    
    
    currentQuota[@"nombre"] = self.txtConcepto.text;
    currentQuota[@"importe"] = [[NSNumber alloc] initWithDouble:[self.txtImporte.text doubleValue]];
    
    currentQuota[@"fbId"] = fbUser.objectID;
    
    
    [self saveDataWithObject:currentQuota];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Actualización completa" message:@"Cuota guardada" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getQuotas" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fallo la actualización" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
    
}

@end
