//
//  ChannelViewCell.m
//  SmartHome
//
//  Created by Apple on 3/6/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ChannelViewCell.h"

@implementation ChannelViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.controlButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
