//
//  CellPlayerQuota.h
//  libero
//
//  Created by Chiunti on 04/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPlayerQuota : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *vCell;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblPlayer;
@property (strong, nonatomic) IBOutlet UILabel *lblPerfil;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipo;
@property (strong, nonatomic) IBOutlet UISwitch *sw;

@end
