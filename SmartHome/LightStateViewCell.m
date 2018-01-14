//
//  LightStateViewCell.m
//  SmartHome
//
//  Created by Apple on 3/31/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "LightStateViewCell.h"

@implementation LightStateViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.valueLabel.text = @"100 %";
    self.onOffButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.thumbnail.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self._backgroundView.layer.cornerRadius = 10.0;
    self._backgroundView.layer.masksToBounds = YES;
    UIImageView *bgzView = (UIImageView *)[self viewWithTag:5];
    if (bgzView) {
        UIImage *inputImage = [UIImage imageNamed:@"ic_device_bg"];
        
        UIImage *xx = [Helper createDimImage:inputImage];
        //bgzView.image = xx;
        
    }

    self.onOffButton.userInteractionEnabled = [[User sharedInstance] canControlDevice:self.device.requestId];
    self.thumbnail.userInteractionEnabled = [[User sharedInstance] canControlDevice:self.device.requestId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)pressedButton:(id)sender {
    
    
    //    self.onOffButton.selected = !self.onOffButton.selected;
    if (self.isScene) {
        self.onOffButton.selected = !self.onOffButton.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedButton:value:)]) {
            if (self.onOffButton.selected) {
                [self.delegate didPressedButton:self.device.id value:ButtonTypeOpen];
            }else{
                [self.delegate didPressedButton:self.device.id value:ButtonTypeClose];
                
            }
        }
    }else{
        if ([[User sharedInstance] canControlDevice:self.device.requestId]) {

            if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedButton:value:)]) {
                if (self.onOffButton.selected) {
                    [self.delegate didPressedButton:self.device.id value:ButtonTypeOpen];
                }else{
                    [self.delegate didPressedButton:self.device.id value:ButtonTypeClose];
                    
                }
            }
        }
    }
}
- (IBAction)pressedControl:(id)sender {
    if ([[User sharedInstance] canControlDevice:self.device.requestId]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedControl:)]) {
            [self.delegate didPressedControl:self.device.id];
        }
    }
   
}

-(void)setContentView:(SceneDetail *)detail{
    self.isScene = true;
    self.device = detail.device;
    self.onOffButton.tag = detail.id;
    self.onOffButton.selected = detail.status == 1;
    self.onOffButton.userInteractionEnabled = YES;
    
    self.lbDeviceName.text = detail.device.name;
    if (detail.isSelected) {
        self._backgroundView.backgroundColor = [UIColor redColor];
    }else{
        self._backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}
-(void)setContentView:(Device *)device type:(NSInteger)type{
    self.device = device;
    self.onOffButton.tag = device.id;
    self.onOffButton.selected = device.state;
    self.onOffButton.userInteractionEnabled = type == 0;
    if (device.name && device.name.length > 0) {
        self.lbDeviceName.text = device.name;
        
    }else{
        self.lbDeviceName.text = device.requestId;
        
    }
}
-(void)setContentView:(Device *)device type:(NSInteger)type selected:(BOOL)selected{
    [self setContentView:device type:type];
    if (selected) {
        self._backgroundView.backgroundColor = [UIColor redColor];
    }else{
        self._backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}
@end

