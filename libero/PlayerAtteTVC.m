//
//  PlayerAtteTVC.m
//  libero
//
//  Created by Chiunti on 03/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "PlayerAtteTVC.h"
#import <Parse/Parse.h>
#import "CellAsistencia.h"
#import "Globals.h"

@interface PlayerAtteTVC ()

@end

@implementation PlayerAtteTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"NewDate" object:nil];
    
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
    
    static NSString *CellIdentifier = @"CellAsistencia";
    
    CellAsistencia *cell = (CellAsistencia *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CellAsistencia" bundle:nil] forCellReuseIdentifier:CellIdentifier];
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
    
    cell.sw.tag = indexPath.row;
    [cell.sw addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
    
    PFQuery *query = [PFQuery queryWithClassName:@"asistencia"];
    [query whereKey:@"jugador" equalTo:object];
    [query whereKey:@"fecha" equalTo:[self dateWithOutTime:currentFecha]];
    
    NSArray *asistencias = [query findObjects];
    
    [cell.sw setOn:asistencias.count>0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) swChanged:(id)sender
{
    UISwitch *sw = (UISwitch *) sender;
    
    currentPlayer = self.objects[sw.tag];
    currentFecha = [self dateWithOutTime:currentFecha];
    
    PFQuery *query = [PFQuery queryWithClassName:@"asistencia"];
    [query whereKey:@"jugador" equalTo:currentPlayer];
    [query whereKey:@"fecha" equalTo:currentFecha];
    
    NSArray *asistencias = [query findObjects];
    
    if (sw.isOn) {
        //nuevo registro
        PFObject *object = [PFObject objectWithClassName:@"asistencia"];
        object[@"fecha"] = currentFecha;
        object[@"jugador"] = currentPlayer;
        
        [object saveInBackground];
    } else {
        // borrar registro
        for (PFObject *object in asistencias) {
            [object deleteInBackground];
        }
        
    }
    
}
-(NSDate *)dateWithOutTime:(NSDate *)datDate{
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:datDate];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPlayer = [self objectAtIndexPath:indexPath];
    //    [self.parentViewController performSegueWithIdentifier:@"ToPlayerEdit" sender:self];
    
    // Notify table view to reload the recipes from Parse cloud
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPlayerDoc" object:self];
    
}
*/
@end
