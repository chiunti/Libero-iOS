//
//  ClubListViewController.m
//  libero
//
//  Created by Chiunti on 17/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "ClubListViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/PFQueryTableViewController.h>
#import "CellClub.h"


@interface ClubListViewController ()

@end

@implementation ClubListViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"club";
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"club"];
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"cellClub";
    
    CellClub *cell = (CellClub *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CellClub alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    
    cell.lblTitle.text = [object objectForKey:@"nombre"];
    
    cell.lblSubtitle.text = [[object objectForKey:@"disciplina"] objectForKey:@"nombre"];
    
    PFFile *theImage = [object objectForKey:@"imagen"];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        
        NSData *imageFile = [theImage getData];
        //Set the animals Icon Image to what ever is intended.
        cell.imgPhoto.image = [UIImage imageWithData:imageFile];
    }];
    
    
    return cell;
}


@end
