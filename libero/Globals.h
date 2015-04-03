//
//  Globals.h
//  libero
//
//  Created by Chiunti on 16/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

#ifndef libero_Globals_h
#define libero_Globals_h


#endif


//NSString *fbId;
//NSString *fbFirstName;
//NSString *fbMiddleName;
//NSString *fbLastName;
//NSString *fbEmail;
UIImage  *fbProfilePicture;
id<FBGraphUser> fbUser;


PFObject *currentUser,*currentClub, *currentPerfil, *currentTeam, *currentDocument, *currentPlayer;
NSDate *currentFecha;


UIAlertView *alertError, *alertGuardar;