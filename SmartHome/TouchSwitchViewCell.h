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
#import "MQTTService.h"
#import "SceneDetail.h"
@interface TouchSwitchViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic)  void(^completionHandler)(NSString *, NSInteger);
@property (strong, nonatomic) Device *device;
@property (strong, nonatomic) SceneDetail *detail;

@property (assign, nonatomic) Boolean isScene;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (weak, nonatomic) IBOutlet UIView *myBackgroundView;
-(void)setContentView:(SceneDetail *)detail;
-(void)setContentValue:(Device *)device;
-(void)setContentView:(Device *)device type:(NSInteger)type;
-(void)setContentView:(Device *)device type:(NSInteger)type selected:(BOOL)selected;


@end
