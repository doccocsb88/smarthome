//
//  SceneDetail.m
//  SmartHome
//
//  Created by Apple on 4/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "SceneDetail.h"

@implementation SceneDetail
@dynamic id;
@dynamic value;
@dynamic status;
@dynamic device;
@dynamic code;
@dynamic key;
@dynamic chanels;
@synthesize isSelected;
@synthesize chanelSelected;
-(BOOL)isChanelOn:(int)chanel{
    if ([self.device numberOfSwitchChannel] > 0 && chanel > 0) {
        if (chanel == 1) {
            if ((int)self.value % 2 == 0) {
                return false;
            }else{
                return true;
            }
        }else if (chanel == 2){
            if (self.value == 2 || self.value == 3 || self.value == 6 || self.value == 7) {
                return true;
            }else{
                return false;
            }
        }else if (chanel == 3){
            if (self.value == 4 || self.value == 5 || self.value == 6 || self.value == 7) {
                return true;
            }else{
                return false;
            }
        }
    }
    return false;
}

-(void)setSelectedChanel:(NSInteger)chanel{
    if (!self.chanelSelected){
        self.chanelSelected = [NSMutableArray new];
    }
    if ([self.chanelSelected containsObject:@(chanel)]) {
        [self.chanelSelected removeObject:@(chanel)];
    }else{
        [self.chanelSelected addObject:@(chanel)];
    }
    self.chanels = @"";
    for (NSString *value in self.chanelSelected){
        if (self.chanels.length == 0) {
            self.chanels = value;
        }else{
            self.chanels = [NSString stringWithFormat:@"%@;%@",self.chanels,value];
        }
    }
}

-(BOOL)isChanelSelected:(NSInteger)chanel{
    return  [self.chanelSelected containsObject:@(chanel)];
}

-(BOOL)hasSelectedDevicel{
    return self.chanelSelected.count > 0;
}

-(NSInteger)numberOfChanel{
    return [self.chanels componentsSeparatedByString:@";"].count;
}
@end

