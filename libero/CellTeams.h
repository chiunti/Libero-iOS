//
//  CellTeams.h
//  libero
//
//  Created by Chiunti on 31/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTeams : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *vCell;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblClub;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo;
@property (strong, nonatomic) IBOutlet UILabel *lblDisciplina;
@property (strong, nonatomic) IBOutlet UILabel *lblRama;

@end
