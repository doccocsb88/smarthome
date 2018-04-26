//
//  RemViewCell.m
//  SmartHome
//
//  Created by Apple on 3/30/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "RemViewCell.h"

@implementation RemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    UIImage *sliderLeftTrackImage = [[UIImage imageNamed: @"ic_slider_thumb"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
//    UIImage *sliderRightTrackImage = [[UIImage imageNamed: @"ic_slider_thumb"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
//    [self.slider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
//    [self.slider setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
    self._backgroundView.layer.cornerRadius = 10.0;
    self._backgroundView.layer.masksToBounds = YES;
    [self.slider setThumbImage:[UIImage imageNamed: @"ic_slider_thumb"] forState:UIControlStateNormal];
//    _slider.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 4.0);
     [self setupValue];
    [self.slider addTarget:self action:@selector(touchEnded:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgzView = (UIImageView *)[self viewWithTag:5];
    if (bgzView) {
        UIImage *inputImage = [UIImage imageNamed:@"ic_device_bg"];

        UIImage *xx = [Helper createDimImage:inputImage];
       // bgzView.image = xx;
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didpressedControl:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedControl:)]) {
        [self.delegate didPressedControl:self.device.id];
    }
}
- (IBAction)pressedButton:(id)sender {
    UIButton *button = (UIButton*)sender;
//    if (self.isScene) {
//        button.selected = !button.selected;
//    }else{
        if (button == self.aButton){
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedButton:value:)]) {
                [self.delegate didPressedButton:self.device.id value:ButtonTypeClose];
            }
        }else if (button == self.bButton){
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedButton:value:)]) {
                [self.delegate didPressedButton:self.device.id value:ButtonTypeStop];
            }
        }else if (button == self.cButton){
            if (self.delegate && [self.delegate respondsToSelector:@selector(didPressedButton:value:)]) {
                [self.delegate didPressedButton:self.device.id value:ButtonTypeOpen];
            }
        }
//    }
}
- (IBAction)valueChanged:(id)sender {
    [self setupValue];
    
}
-(void)setContentView:(SceneDetail *)detail{
    self.isScene = true;
    self.device = detail.device;
    self.slider.value = detail.value;
    self.slider.tag = detail.id;
    self.nameLabel.text  = detail.device.name;

//    self.slider.userInteractionEnabled = type == 0;
//    self.aButton.userInteractionEnabled = type == 0;
//    self.bButton.userInteractionEnabled = type == 0;
//    self.cButton.userInteractionEnabled = type == 0;
    if (detail.status == ButtonTypeStop) {
        self.aButton.selected = NO;
        self.bButton.selected = YES;
        self.cButton.selected = NO;
    }else if (detail.status == ButtonTypeOpen) {
        self.aButton.selected = NO;
        self.bButton.selected = NO;
        self.cButton.selected = YES;
    }else{
        self.aButton.selected = YES;
        self.bButton.selected = NO;
        self.cButton.selected = NO;
    }
    [self setupValue];
    
    if (detail.isSelected) {
        self._backgroundView.backgroundColor = [UIColor redColor];
    }else{
        self._backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}
-(void)setContentView:(Device *)device type:(NSInteger)type{
    self.device = device;
    self.slider.value = device.value;
    self.slider.tag = device.id;
    self.slider.userInteractionEnabled = type == 0;
    self.aButton.userInteractionEnabled = type == 0;
    self.bButton.userInteractionEnabled = type == 0;
    self.cButton.userInteractionEnabled = type == 0;
    self.nameLabel.text  = device.name;
    BOOL isOpen = device.value < 100 ? YES : NO;
    if (isOpen) {
        self.aButton.selected = NO;
        self.bButton.selected = NO;
        self.cButton.selected = YES;
    }else{
        self.aButton.selected = YES;
        self.bButton.selected = NO;
        self.cButton.selected = NO;
    }
    [self setupValue];
}
-(void)setContentView:(Device *)device type:(NSInteger)type selected:(BOOL)selected{
    [self setContentView:device type:type];
    if (selected) {
        self._backgroundView.backgroundColor = [UIColor redColor];
    }else{
        self._backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
}
-(void)setupValue{
    NSInteger value = self.slider.value / 10;
    //self.valueLabel.text = [NSString stringWithFormat:@"%ld %@",value,@"%"];
    NSString *name = [NSString stringWithFormat:@"icon_curtain2_%ld0ldpi",value];
//    NSLog(@"name ____ : %@",name);
        self.thumbnail.image = [UIImage imageNamed:name];
 

}

-(void)touchEnded:(UISlider *)sender{
    if([self.delegate respondsToSelector:@selector(didChangeValueForKey:)]){
        [self.delegate didChangeCell:self.slider.tag value:self.slider.value];
    }
}
@end
