//
//  CellQuota.m
//  libero
//
//  Created by Chiunti on 04/04/15.
//  Copyright (c) 2015 chiunti. All rights reserved.
//

#import "CellQuota.h"

@implementation CellQuota

- (void)awakeFromNib {
    // Initialization code
    self.vCell.layer.borderColor    = [UIColor clearColor].CGColor;
    self.vCell.layer.borderWidth    = 1;
    self.vCell.clipsToBounds        = YES;
    self.vCell.layer.cornerRadius   = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
