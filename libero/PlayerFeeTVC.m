//
//  PlayerFeeTVC.m
//  libero
//
//  Created by Chiunti on 04/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "PlayerFeeTVC.h"
#import <Parse/Parse.h>
#import "CellPlayerQuota.h"
#import "Globals.h"

@interface PlayerFeeTVC ()

@end

@implementation PlayerFeeTVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"NewQuota" object:nil];
    
}


- (void) viewDidAppear:(BOOL)animated
{
    currentQuota = nil;
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
    
    static NSString *CellIdentifier = @"CellPlayerQuota";
    
    CellPlayerQuota *cell = (CellPlayerQuota *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CellPlayerQuota" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    cell.hidden = YES;
    
    if (currentQuota){
    
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
        
        cell.sw.tag = indexPath.row;
        [cell.sw addTarget:self action:@selector(swPChanged:) forControlEvents:UIControlEventValueChanged];
        
        PFQuery *query = [PFQuery queryWithClassName:@"cuotasjugador"];
        [query whereKey:@"jugador" equalTo:object];
        [query whereKey:@"cuota" equalTo:currentQuota];
        
        NSArray *cuotas = [query findObjects];
        
        [cell.sw setOn:cuotas.count>0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hidden = NO;
        
        // set background on selected cell
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:0.6];
        bgColorView.layer.cornerRadius = 8;
        bgColorView.frame = cell.vCell.frame;
        bgColorView.layer.masksToBounds = YES;
        [cell setSelectedBackgroundView:bgColorView];
    
    }
    
   

    
    return cell;
}

// Override to customize the look of the cell that allows the user to load the next page of objects.
// The default implementation is a UITableViewCellStyleDefault cell with simple labels.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"más...";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    

    // set background on selected cell
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    bgColorView.layer.cornerRadius = 8;
    bgColorView.frame = cell.frame;
    bgColorView.layer.masksToBounds = YES;
    [cell setBackgroundView:bgColorView];
    
    
    return cell;
}


- (void) swPChanged:(id)sender
{
    UISwitch *sw = (UISwitch *) sender;
    
    currentPlayer = self.objects[sw.tag];
    
    PFQuery *query = [PFQuery queryWithClassName:@"cuotasjugador"];
    [query whereKey:@"jugador" equalTo:currentPlayer];
    [query whereKey:@"cuota" equalTo:currentQuota];
    
    NSArray *cuotas = [query findObjects];
    
    if (sw.isOn) {
        //nuevo registro
        PFObject *object = [PFObject objectWithClassName:@"cuotasjugador"];
        object[@"cuota"] = currentQuota;
        object[@"jugador"] = currentPlayer;
        
        [object saveInBackground];
    } else {
        // borrar registro
        for (PFObject *object in cuotas) {
            [object deleteInBackground];
        }
        
    }
    
}
@end
