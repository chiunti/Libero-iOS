//
//  QuotasTVC.m
//  libero
//
//  Created by Chiunti on 04/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "QuotasTVC.h"
#import <Parse/Parse.h>
#import "CellQuota.h"
#import "Globals.h"

@interface QuotasTVC ()

@end

@implementation QuotasTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"getQuotas" object:nil];
    
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
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"";
}
*/
#pragma mark - Navigation

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"cuota";
        
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
    [query orderByDescending:@"createdAt"];
    return query;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"CellQuota";
    
    CellQuota *cell = (CellQuota *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CellQuota" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    // Configure the cell
    cell.lblQuota.text = [object objectForKey:@"nombre"];
    cell.lblImporte.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"importe"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentQuota = [self objectAtIndexPath:indexPath];
    //    [self.parentViewController performSegueWithIdentifier:@"ToPlayerEdit" sender:self];
    
    // Notify table view to reload the recipes from Parse cloud
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewQuota" object:self];
    
}

//Borrar registro
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Borrar";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the row from data model
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    }
}


@end
