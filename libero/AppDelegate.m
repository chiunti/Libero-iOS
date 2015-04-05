//
//  AppDelegate.m
//  libero
//
//  Created by Chiunti on 09/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Globals.h"
#import "Reachability.h"


UIView *view, *backgroundView;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    Reachability
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.parse.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        NSLog(@"REACHABLE!");
        [self reachable];
        //dispatch_async(dispatch_get_main_queue(), ^{
        //    NSLog(@"REACHABLE!");
        //});
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [self unreachable];
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    
    
    ////    Parse
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"Ntf5b88yQRyt602L9INQZoy9eAnTVj8OfNgZruDt"
                  clientKey:@"ybmgHbNGO5IFfICbMPxexN5oNKYPgk1gziT1sXrI"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    
    //// facebook
    
    // Whenever a person opens app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // Call this method EACH time the session state changes,
                                          //  NOT just when the session open
                                        [self sessionStateChanged:session state:state error:error];
                                      }];

        
     
    }
    // Override point for customization after application launch.
    
    
    
    // esta condicion será cuando ya se encuentra configurada la aplicacion
    firstrunning = true;
    
    NSLog(@"launch Home");
    if (false) {
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Logs 'install' and 'app activate' App Events.
    //[FBAppEvents activateApp];
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

    // During login, your app passes control to
    // Facebook iOS app or Facebook in a mobile browser.
    // After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}
    
// Handles session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

-(void) userLoggedIn{
    NSLog(@"loggedin");
}

-(void) userLoggedOut{
    NSLog(@"logged off");
    
}

-(void) showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle{
    NSLog(@"%@",alertText);
}

-(void) unreachable{
    
    // Window bounds.
    //CGRect bounds = _window.bounds;
    
    // Create a view and add it to the window.
    if (!view) {
        backgroundView = [[UIView alloc] initWithFrame: _window.bounds];
        view = [[UIView alloc] initWithFrame: CGRectMake((_window.frame.size.width-200)/2, -200, 200, 200)];
        [view setBackgroundColor: [UIColor whiteColor]];
        view.layer.borderColor    = [UIColor clearColor].CGColor;
        view.layer.borderWidth    = 1;
        view.clipsToBounds        = YES;
        view.layer.cornerRadius   = 10;
        [backgroundView setBackgroundColor: [UIColor blackColor]];
        [backgroundView setAlpha:0.5f];
        
    
    
        // Create a label and add it to the view.
        CGRect labelFrame = CGRectMake( 0, 0, 200, 30 );
        UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText: @"Líbero"];
        [label setBackgroundColor:[UIColor blueColor]];
        [label setTextColor:[UIColor whiteColor]];
        //label.layer.cornerRadius = 10;
        [view addSubview: label];
        
        // Create a label and add it to the view.
        labelFrame = CGRectMake( 10, 85, 180, 30 );
        label = [[UILabel alloc] initWithFrame: labelFrame];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText: @"No hay internet"];
        [view addSubview: label];
    }
    
    [_window addSubview: backgroundView];
    [_window addSubview: view];
    [_window makeKeyAndVisible];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.frame = CGRectMake((_window.frame.size.width-200)/2, 20, 200, 200);
                     }
                     completion:^(BOOL finished){
                     }];
    //[self.view addSubview:view];
}

-(void) reachable
{
    if (view) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.frame = CGRectMake((_window.frame.size.width-200)/2, -200, 200 , 200);
                         }
                         completion:^(BOOL finished){
                             if (finished){
                                 [view removeFromSuperview];
                                 [backgroundView removeFromSuperview];
                             }
                         }];
    }
}


@end
