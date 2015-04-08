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

UIView *vQuota;
UIView *backgroundView;
CGFloat altura = 200;
PFObject *currentAbono;
CellPlayerQuota *cell;
UISwitch *sw;
UITextField *txtView;
UILabel *lblCuota;
UILabel *lblDebe;

@interface PlayerFeeTVC ()

@end


@implementation PlayerFeeTVC



- (void)viewDidLoad {

    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"NewQuota" object:nil];
    
    [self createCaptureView];

    
}

-(void) createCaptureView
{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              [UIScreen mainScreen].bounds.size.width,
                                                              [UIScreen mainScreen].bounds.size.height)
                      ];
    backgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f];
    
    
    vQuota = [[UIView alloc] initWithFrame:CGRectMake(0, -altura, [UIScreen mainScreen].bounds.size.width, altura) ];
    [vQuota setBackgroundColor: [UIColor whiteColor]];
    vQuota.layer.borderColor    = [UIColor clearColor].CGColor;
    vQuota.layer.borderWidth    = 1;
    vQuota.clipsToBounds        = YES;
    vQuota.layer.cornerRadius   = 10;
    
    // Create a label and add it to the view.
    CGRect labelFrame = CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.width, 30 );
    UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText: @"Líbero: Cuota"];
    [label setBackgroundColor:[UIColor blueColor]];
    [label setTextColor:[UIColor whiteColor]];
    label.layer.cornerRadius = 8;
    [vQuota addSubview: label];
    
    
    // Create a label and add it to the view.
    labelFrame = CGRectMake( 10, 60, 130, 30 );
    lblCuota = [[UILabel alloc] initWithFrame: labelFrame];
    lblCuota.text = @"abono";
    [vQuota addSubview: lblCuota];
    
    
    // Create a label and add it to the view.
    labelFrame = CGRectMake( 10, 30, [UIScreen mainScreen].bounds.size.width-20, 30 );
    lblCuota = [[UILabel alloc] initWithFrame: labelFrame];
    [vQuota addSubview: lblCuota];
    
    
    labelFrame = CGRectMake( [UIScreen mainScreen].bounds.size.width-150, 60, 130, 30 );
    txtView = [[UITextField alloc] initWithFrame:labelFrame];
    [txtView setPlaceholder:@"Abono"];
    txtView.keyboardType = UIKeyboardTypeDecimalPad;
    txtView.borderStyle = UITextBorderStyleRoundedRect;
    txtView.textAlignment = NSTextAlignmentRight;
    txtView.clearButtonMode = UITextFieldViewModeAlways;
    [vQuota addSubview: txtView];
    
    labelFrame =  CGRectMake( 10, 130, 130, 30 );
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:labelFrame];
    [btnCancel setTitle:@"Cancelar" forState:UIControlStateNormal];
    btnCancel.layer.cornerRadius = 8;
    [btnCancel addTarget:self
               action:@selector(btnCancelPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setBackgroundColor:[UIColor grayColor]];
    [vQuota addSubview: btnCancel];
    
    
    labelFrame =  CGRectMake( [UIScreen mainScreen].bounds.size.width-140, 130, 130, 30 );
    UIButton *btnok = [[UIButton alloc] initWithFrame:labelFrame];
    [btnok setTitle:@"Aceptar" forState:UIControlStateNormal];
    btnok.layer.cornerRadius = 8;
    [btnok addTarget:self
                  action:@selector(btnOkPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [btnok setBackgroundColor:[UIColor grayColor]];
    [vQuota addSubview: btnok];
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
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];

    
    
    
    cell = (CellPlayerQuota *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CellPlayerQuota" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    cell.hidden = YES;
    
    if (currentQuota){
    
        // Configure the cell
        cell.lblPlayer.text = [object objectForKey:@"nombre"];
        
        /*
        PFObject *perfil = [object objectForKey:@"perfil"];
        [perfil fetch];
        cell.lblPerfil.text = [perfil objectForKey:@"nombre"];
        */
        
        PFObject *equipo = [object objectForKey:@"equipo"];
        [equipo fetch];
        cell.lblPerfil.text = [equipo objectForKey:@"nombre"];

        
        
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
       
        cell.lblEquipo.text = @"";
        cell.lblEquipo.textAlignment = NSTextAlignmentRight;
        cell.lblEquipo.layer.cornerRadius = 5;
        cell.lblEquipo.clipsToBounds = YES;
        cell.lblEquipo.backgroundColor = [UIColor clearColor];
        
        if (cuotas.count>0) {
            PFObject *estaQuota = [cuotas objectAtIndex:0];
            NSNumber *ndebe     = [estaQuota objectForKey:@"debe"];
            NSNumber *ncambio   = [estaQuota objectForKey:@"cambio"];
            if ([ndebe doubleValue]>0) {
                cell.lblEquipo.text = [currencyStyle stringFromNumber:ndebe];
                cell.lblEquipo.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            } else if ([ncambio doubleValue]>0) {
                cell.lblEquipo.text = [currencyStyle stringFromNumber:ncambio];
                cell.lblEquipo.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
            } else {
                cell.lblEquipo.text = @"OK";
                cell.lblEquipo.textAlignment = NSTextAlignmentCenter;
                cell.lblEquipo.textColor = [UIColor greenColor];
            }
        }
        
        
        
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


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = (CellPlayerQuota*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.sw.isOn) {
   
        PFQuery *query = [PFQuery queryWithClassName:@"cuotasjugador"];
        [query whereKey:@"jugador" equalTo:[self objectAtIndexPath:indexPath]];
        [query whereKey:@"cuota" equalTo:currentQuota];
        
        NSArray *cuotas = [query findObjects];
        if (cuotas.count>0){
            currentAbono = [cuotas objectAtIndex:0];
            sw = cell.sw;
            [self verCaptura];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}


- (void) swPChanged:(id)sender
{
    sw = (UISwitch *) sender;

    
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
        
        currentAbono = object;
        [self verCaptura];
        
    } else {
        // borrar registro
        for (PFObject *object in cuotas) {
            [object deleteInBackground];
        }
        // quitar etiqueta
        //cell.lblEquipo.text = @"";
        //cell.lblEquipo.backgroundColor = [UIColor clearColor];
        
        [self refreshCellForRow:sw.tag];
        
    }
    
}

-(void)refreshCellForRow:(NSInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

-(void)btnCancelPressed
{
    //[sw setOn:false];
    [self ocultarCaptura];
    [self refreshCellForRow:sw.tag];
}

-(void)btnOkPressed
{
    NSNumber *importe = [currentQuota objectForKey:@"importe"];
    NSNumber *abono =   [[NSNumber alloc] initWithDouble:[txtView.text doubleValue]];
    
    currentAbono[@"abono"] = [[NSNumber alloc] initWithDouble:[txtView.text doubleValue]];
    if ([importe doubleValue] >= [abono doubleValue])
    {
        currentAbono[@"debe"] =  [[NSNumber alloc] initWithDouble: ([importe doubleValue] - [abono doubleValue])];
        currentAbono[@"cambio"] = @0;
    } else {
        currentAbono[@"cambio"] =  [[NSNumber alloc] initWithDouble: ([abono doubleValue] - [importe doubleValue])];
        currentAbono[@"debe"] = @0;

    }
    [currentAbono saveInBackground];
    
    [self ocultarCaptura];
    
    [self refreshCellForRow:sw.tag];

    
    
}

-(void)verCaptura
{
    [txtView becomeFirstResponder];
    txtView.text = [currentAbono[@"abono"] stringValue];
    [lblCuota setText: [NSString stringWithFormat:@"%@: $%@", [currentQuota objectForKey:@"nombre"],[currentQuota objectForKey:@"importe"]]];
    [self.parentViewController.view addSubview:backgroundView];
    [self.parentViewController.view addSubview:vQuota];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         vQuota.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, altura);
                     }
                     completion:^(BOOL finished){
                     }];
  
    
}

-(void)ocultarCaptura
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         vQuota.frame = CGRectMake(0, -altura, [UIScreen mainScreen].bounds.size.width, altura);
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [vQuota removeFromSuperview];
                             [backgroundView removeFromSuperview];
                         }
                     }];
}
@end
