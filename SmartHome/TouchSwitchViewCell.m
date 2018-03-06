//
//  TouchSwitchViewCell.m
//  
//
//  Created by Apple on 3/6/18.
//

#import "TouchSwitchViewCell.h"

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

-(void)setContentValue:(Device *)device{
    self.device = device;
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
    if (indexPath.row == 0) {
        if ((int)self.device.value % 2 == 0) {
            cell.onOffButton.selected = false;
        }else{
            cell.onOffButton.selected = true;
        }
    }else if (indexPath.row == 1){
        if (self.device.value == 2 || self.device.value == 3 || self.device.value == 6 || self.device.value == 7) {
            cell.onOffButton.selected = true;
        }else{
            cell.onOffButton.selected = false;
        }
    }else if (indexPath.row == 2){
        if (self.device.value >= 4.0) {
            cell.onOffButton.selected = true;
        }else{
            cell.onOffButton.selected = false;
        }
    }
    return cell;
}

/**/
-(void)didPressedOnOff:(UIButton *)sender{
    NSLog(@"TouchSwitchViewCell : ");
    NSInteger tag = sender.tag;
    if (tag > 0) {
//        id=’WT3-0000000003/1’ cmd=’ON’ value=’W3,2,1’
        if (tag == 1) {
            //chenal 1
            if ((int)self.device.value % 2 == 0) {
                self.device.value += 1;
            }else{
                self.device.value -= 1;
            }
        }else if (tag == 2){
            //chenal 2
            if (self.device.value == 2 || self.device.value == 3 || self.device.value == 6 || self.device.value == 7) {
                self.device.value -= 2;
            }else{
                self.device.value += 2;
            }
        }else if (tag == 3){
            //chenal 3
            if (self.device.value >= 4) {
                self.device.value -= 4;
            }else{
                self.device.value += 4;
            }
        }
    }
    [[CoredataHelper sharedInstance] save];
    [self.tableView reloadData];
}
@end
