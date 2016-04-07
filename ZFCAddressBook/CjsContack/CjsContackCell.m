//
//  CjsContackCell.m
//  cjsuser
//
//  Created by 周福昌 on 15/10/29.
//  Copyright © 2015年 M-C_mac. All rights reserved.
//

#import "CjsContackCell.h"

@implementation CjsContackCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
