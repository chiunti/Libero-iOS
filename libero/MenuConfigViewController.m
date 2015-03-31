//
//  MenuConfig.m
//  libero
//
//  Created by Chiunti on 16/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "MenuConfigViewController.h"
#import <Parse/Parse.h>
#import "Globals.h"

@implementation MenuConfigViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    [self initController];
    
}

-(void) initController
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"usuario"];
    //[query fromLocalDatastore];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            //NSArray *arreglo = [query findObjects];
            if (objects.count == 0 ){
                self.btnClub.enabled = NO;
                self.btnClub.alpha = 0.3f;
                self.btnPerfiles.enabled = NO;
                self.btnPerfiles.alpha = 0.3f;
                self.btnDocumentacion.enabled = NO;
                self.btnDocumentacion.alpha = 0.3f;
            } else {
                self.btnClub.enabled = YES;
                self.btnClub.alpha = 0.75f;
                self.btnPerfiles.enabled = YES;
                self.btnPerfiles.alpha = 0.75f;
                self.btnDocumentacion.enabled = YES;
                self.btnDocumentacion.alpha = 0.75f;            }
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];

    query = [PFQuery queryWithClassName:@"club"];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            //NSArray *arreglo = [query findObjects];
            if (objects.count == 0 ){
                self.btnEquipos.enabled = NO;
                self.btnEquipos.alpha = 0.3f;

            } else {
                self.btnEquipos.enabled = YES;
                self.btnEquipos.alpha = 0.75f;

            }
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];

}

@end
