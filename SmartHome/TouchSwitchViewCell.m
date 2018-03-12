//
//  TouchSwitchViewCell.m
//  
//
//  Created by Apple on 3/6/18.
//

#import "TouchSwitchViewCell.h"
@interface TouchSwitchViewCell()
@property (assign, nonatomic) float value;
@end
@implementation TouchSwitchViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
      [self.tableView registerNib:[UINib nibWithNibName:@"ChannelViewCell" bundle:nil] forCellReuseIdentifier:@"ChannelViewCell"];
    self.myBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.myBackgroundView.layer.cornerRadius = 5.0;
    self.myBackgroundView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContentView:(SceneDetail *)detail{
    self.isScene = true;
    self.detail = detail;
    [self setContentValue:detail.device];
    if (detail.isSelected) {
        self.myBackgroundView.backgroundColor = [UIColor redColor];
    }else{
        self.myBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}
-(void)setContentValue:(Device *)device{
    self.device = device;
    self.deviceNameLabel.text = self.device.name;
    [self.tableView reloadData];
}
-(void)setContentView:(Device *)device type:(NSInteger)type{
    [self setContentValue:device];
    self.tableView.userInteractionEnabled = type == 0;
}
-(void)setContentView:(Device *)device type:(NSInteger)type selected:(BOOL)selected{
    [self setContentView:device type:type];
    if (selected) {
        self.myBackgroundView.backgroundColor = [UIColor redColor];
    }else{
        self.myBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelViewCell" forIndexPath:indexPath];;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.onOffButton.tag = indexPath.row + 1;
    [cell.onOffButton addTarget:self action:@selector(didPressedOnOff:) forControlEvents:UIControlEventTouchUpInside];
    float deviceValue = self.device.value;
    if (self.isScene) {
        deviceValue = self.detail.value;
    }
    if (indexPath.row == 0) {
        if ((int)deviceValue % 2 == 0) {
            cell.onOffButton.selected = false;
        }else{
            cell.onOffButton.selected = true;
        }
    }else if (indexPath.row == 1){
        if (deviceValue == 2 || deviceValue == 3 || deviceValue == 6 || deviceValue == 7) {
            cell.onOffButton.selected = true;
        }else{
            cell.onOffButton.selected = false;
        }
    }else if (indexPath.row == 2){
        if (deviceValue >= 4.0) {
            cell.onOffButton.selected = true;
        }else{
            cell.onOffButton.selected = false;
        }
    }
    NSString *nameKey = [NSString stringWithFormat:@"name%ld",indexPath.row+1];
    NSString *jsonString = self.device.chanelInfo;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"change touch switch name  : %@", jsonString);
    NSString *name = [json objectForKey:nameKey];
    if (name && name.length > 0) {
        cell.nameLabel.text = name;
    }else{
        cell.nameLabel.text = [NSString stringWithFormat:@"Đèn %ld",indexPath.row + 1];
    }
    cell.controlButton.tag = indexPath.row + 1;
    [cell.controlButton addTarget:self action:@selector(didPressedControl:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/**/
-(void)didPressedOnOff:(UIButton *)sender{
    NSLog(@"TouchSwitchViewCell : ");
    NSInteger tag = sender.tag;
    self.value = self.device.value;

    if (self.isScene) {
        self.value = self.detail.value;
    }
    if (tag > 0) {
//        id=’WT3-0000000003/1’ cmd=’ON’ value=’W3,2,1’
        BOOL cmd = false;
        if (tag == 1) {
            //chenal 1
            if ((int)self.value % 2 == 0) {
                self.value += 1;
                cmd = true;
            }else{
                self.value -= 1;
            }
        }else if (tag == 2){
            //chenal 2
            if (self.value == 2 || self.value == 3 || self.value == 6 || self.value == 7) {
                self.value -= 2;
            }else{
                self.value += 2;
                cmd = true;

            }
        }else if (tag == 3){
            //chenal 3
            if (self.value == 4 || self.value == 5 || self.value == 6 || self.value == 7) {
                self.value -= 4;
            }else{
                self.value += 4;
                cmd = true;

            }
        }
        if (self.isScene) {
            self.detail.value = self.value;
            if (self.completionHandler) {
                self.completionHandler([NSString stringWithFormat:@"%f",self.value],tag);
                
            }
        }else{
//            self.device.value = self.value;
            [[MQTTService sharedInstance] publishControl:self.device.requestId message:[self.device switchChancelMessage:(int)tag status:cmd] type:self.device.type count:0];
            if (self.controlHandler) {
                self.controlHandler();
            }
        }

    }
//    [[CoredataHelper sharedInstance] save];
//    [self.tableView reloadData];
}

-(void)didPressedControl:(UIButton *)button{
    if (self.completionHandler) {
        self.completionHandler([NSString stringWithFormat:@"%f",self.value],button.tag);
        
    }
}
@end
