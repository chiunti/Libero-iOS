//
//  MenuConfig.m
//  libero
//
//  Created by Chiunti on 16/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "MenuConfig.h"
#import <Parse/Parse.h>
#import "Globals.h"

@implementation MenuConfig


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
    NSArray *arreglo = [query findObjects];
    if (arreglo.count == 0 ){
        self.btnClub.enabled = NO;
        self.btnClub.alpha = 0.3f;
        self.btnPerfiles.enabled = NO;
        self.btnPerfiles.alpha = 0.3f;
    } else {
        self.btnClub.enabled = YES;
        self.btnClub.alpha = 0.75f;
        self.btnPerfiles.enabled = YES;
        self.btnPerfiles.alpha = 0.75f;
    }

    
}

@end
