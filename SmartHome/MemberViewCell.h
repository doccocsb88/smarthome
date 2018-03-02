//
//  MemberViewCell.h
//  SmartHome
//
//  Created by Apple on 1/8/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *shareButton;
@property (strong, nonatomic) void (^simpleBlock)(NSInteger);
@end
