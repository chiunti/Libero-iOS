//
//  ViewController.m
//  libero
//
//  Created by Chiunti on 09/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "ConfigurationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "Globals.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
    
    // Do any additional setup after loading the view, typically from a nib.
    self.loginView2.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    for (id obj in self.loginView2.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Entrar a facebook";
            
        }
    }
    self.btnSalir.hidden = true;
    self.btnConfig.hidden = true;
    self.btnToMain.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    
    return YES;
}

// Call method when user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"User Id %@",user.objectID);
    fbUser       = user;
    //fbId         = user.objectID;
    //fbFirstName  = user.first_name;
    //fbMiddleName = user.middle_name;
    //fbLastName   = user.last_name;
    //fbEmail      = [user objectForKey:@"email"];
    
    
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;
    
    
    if (firstrunning){
        [self performSegueWithIdentifier:@"InitToHome" sender:self];
    }
    
    
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {

    //self.statusLabel.text = @"You're logged in as";
    self.statusLabel.text = @"";
    for (id obj in self.loginView2.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Salir de facebook";

        }
    }
    
    self.loginView2.hidden = true;
    self.btnConfig.hidden  = false;
    self.btnSalir.hidden = false;
    self.btnToMain.hidden = false;
    
    /*
    FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"/me/taggable_friends"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (!error) {
            
            NSArray* friends = [result objectForKey:@"data"];
            NSLog(@"Found: %lu friends", (unsigned long)friends.count);
            for (NSDictionary<FBGraphUser>* friend in friends) {
                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            }
        } else {
            NSLog(@"error %@", error.description);
        }
    }];
   */
    for (NSObject *obj in [self.profilePictureView subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView *objImg = (UIImageView *)obj;
            fbProfilePicture = objImg.image;
            break;
        }
    }

}



// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"Necesitas entrar con Facebook!";
    //Change button text
    for (id obj in self.loginView2.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Entrar a facebook";
            
        }
    }
    self.loginView2.hidden = false;
    self.btnConfig.hidden  = true;
    self.btnSalir.hidden   = true;
    self.btnToMain.hidden  = true;


}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user performs an action outside of you app to recover,
    // the SDK provides a message, you just need to surface it.
    // This handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
        
        for (id obj in self.loginView2.subviews)
        {
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel * loginLabel =  obj;
                loginLabel.text = @"Facebook es necesario";
                
            }
        }
        
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

}


- (IBAction)loginPressed:(id)sender {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

@end
