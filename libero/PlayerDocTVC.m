//
//  PlayerDocTVC.m
//  libero
//
//  Created by Chiunti on 03/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "PlayerDocTVC.h"
#import <Parse/Parse.h>
#import "CellPlayers.h"
#import "Globals.h"

@interface PlayerDocTVC ()

@end

@implementation PlayerDocTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"getPlayers" object:nil];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    currentPlayer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Jugadores";
}

#pragma mark - Navigation

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"jugador";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"nombre";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 9;
    }
    return self;
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    
    // Order by sport type
    [query orderByAscending:@"equipo"];
    return query;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"CellPlayers";
    
    CellPlayers *cell = (CellPlayers *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CellPlayers" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    
    
    
    
    // Configure the cell
    cell.lblPlayer.text = [object objectForKey:@"nombre"];
    
    PFObject *perfil = [object objectForKey:@"perfil"];
    [perfil fetch];
    cell.lblPerfil.text = [perfil objectForKey:@"nombre"];
    
    PFObject *equipo = [object objectForKey:@"equipo"];
    [equipo fetch];
    cell.lblEquipo.text = [equipo objectForKey:@"nombre"];
    
    
    PFFile *theImage = [object objectForKey:@"imagen"];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        
        NSData *imageFile = [theImage getData];
        //Set the Icon Image to what ever is intended.
        cell.imgPhoto.image = [UIImage imageWithData:imageFile];
    }];
    

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPlayer = [self objectAtIndexPath:indexPath];
//    [self.parentViewController performSegueWithIdentifier:@"ToPlayerEdit" sender:self];
    
    // Notify table view to reload the recipes from Parse cloud
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPlayerDoc" object:self];
    
}


@end
