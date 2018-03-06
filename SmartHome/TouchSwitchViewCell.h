//
//  TouchSwitchViewCell.h
//  
//
//  Created by Apple on 3/6/18.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "ChannelViewCell.h"
#import "CoredataHelper.h"
@interface TouchSwitchViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) Device *device;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *myBackgroundView;
-(void)setContentValue:(Device *)device;
@end
