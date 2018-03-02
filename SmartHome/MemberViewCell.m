//
//  MemberViewCell.m
//  SmartHome
//
//  Created by Apple on 1/8/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "MemberViewCell.h"

@implementation MemberViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didPressedShare:(id)sender {
    UISwitch *sharebutton = (UISwitch *)sender;
    NSInteger tag = sharebutton.tag;
    if(_simpleBlock){
        _simpleBlock(tag);
    }
    
}

@end
