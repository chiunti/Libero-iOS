//
//  DocPlayerTVC.m
//  libero
//
//  Created by Chiunti on 03/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "DocPlayerTVC.h"
#import <Parse/Parse.h>
#import "CellDocument.h"
#import "Globals.h"

@interface DocPlayerTVC ()

@end

@implementation DocPlayerTVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"NewPlayerDoc" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    currentDocument= nil;
    currentPlayer=nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    currentDocument= nil;
    currentPlayer=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Documentos";
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"documento";
        
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

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"documento"];
    //[query whereKey:<#(NSString *)#> equalTo:<#(id)#>]
    [query whereKey:@"fbId" equalTo:fbUser.objectID];
    [query orderByAscending:@"nombre"];
    
    return query;
}


//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"CellDocument";
    
    CellDocument *cell = (CellDocument *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CellDocument" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    
    
    
    
    // Configure the cell
    cell.lblDocument.text = [object objectForKey:@"nombre"];
    
    if (currentPlayer) {
        cell.sw.hidden = NO;
        cell.sw.tag = indexPath.row;
        
        [cell.sw addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];

        PFQuery *query = [PFQuery queryWithClassName:@"doctosjugador"];
        [query whereKey:@"jugador" equalTo:currentPlayer];
        [query whereKey:@"documento" equalTo:object];
        
        NSArray *doctosjugador = [query findObjects];
        
        [cell.sw setOn:doctosjugador.count>0];
        cell.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        //cell.sw.hidden = YES;
        cell.hidden = YES;
    }
    return cell;
}

- (void) swChanged:(id)sender
{
    UISwitch *sw = (UISwitch *) sender;
    
    currentDocument = self.objects[sw.tag];
    
    PFQuery *query = [PFQuery queryWithClassName:@"doctosjugador"];
    [query whereKey:@"jugador" equalTo:currentPlayer];
    [query whereKey:@"documento" equalTo:currentDocument];
    
    NSArray *doctosjugador = [query findObjects];
    
    if (sw.isOn) {
        //nuevo registro
        PFObject *object = [PFObject objectWithClassName:@"doctosjugador"];
        object[@"documento"] = currentDocument;
        object[@"jugador"] = currentPlayer;
        
        [object saveInBackground];
    } else {
        // borrar registro
        for (PFObject *object in doctosjugador) {
            [object deleteInBackground];
        }
        
    }
    
}
/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentDocument = [self objectAtIndexPath:indexPath];
    [self.parentViewController performSegueWithIdentifier:@"ToDocumentEdit" sender:self];
}
*/
@end
