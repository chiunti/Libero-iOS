//
//  CellClub.h
//  libero
//
//  Created by Chiunti on 16/03/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellClub : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *vCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;

@end
