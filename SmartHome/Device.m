//
//  Device.m
//  SmartHome
//
//  Created by Apple on 3/30/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "Device.h"
#import "Utils.h"
@implementation Device
@dynamic id;
@dynamic name;
@dynamic state;
@dynamic value;
@dynamic type;
@dynamic token;
@dynamic requestId;
@dynamic topic;
@dynamic image;
@dynamic order;
@dynamic control;
@synthesize isSubcrible;
@synthesize isGetStatus;
@synthesize key;
@dynamic chanelInfo;
-(NSString *)getAddMessage{
    return [NSString stringWithFormat:@"id='%@' cmd='ADDDEV'",self.requestId];
}
-(NSString *)getDelMessage{
    return [NSString stringWithFormat:@"id='%@' cmd='DELDEV'",self.requestId];
}
-(NSString *)getTopic{
    if (self.type  == DeviceTypeCurtain) {
        return [NSString stringWithFormat:@"QA_CC_%@",self.requestId];
    }else if (self.type == DeviceTypeTouchSwitch){
        return self.requestId;
    }
    return [Utils getTopic];
}

-(NSInteger )numberOfSwitchChannel{
    if (self.type == DeviceTypeTouchSwitch) {
        NSString *prefix = [self.requestId componentsSeparatedByString:@"-"][0];
        if ([prefix isEqualToString:@"WT3"]) {
            return 3;
        }else  if ([prefix isEqualToString:@"WT2"]) {
            return 2;
        }else if ([prefix isEqualToString:@"WT1"]) {
            return 1;
        }
        
    }
    return 0;
}
-(NSString *)switchChancelMessage:(int)chanel status:(Boolean)status{
//    id=’WT3-0000000003/1’ cmd=’ON’ value=’W3,2,1’
//    id=’WT3-0000000003/1’ cmd=’OFF value=’W3,2,0’
    NSString *stageString = status?@"ON":@"OFF";
    NSString *valueString = @"";
    NSString *prefix = [self.requestId componentsSeparatedByString:@"-"][0];
    if ([prefix isEqualToString:@"WT3"]) {
        valueString = status?@"W3,2,1":@"W3,2,0";
    }else if ([prefix isEqualToString:@"WT2"]) {
        valueString = status?@"W2,2,1":@"W2,2,0";

    }else if ([prefix isEqualToString:@"WT1"]) {
        valueString = status?@"W1,2,1":@"W1,2,0";
    }
    NSString *message =  [NSString stringWithFormat:@"id='%@/%d' cmd='%@' value='%@'",self.requestId,chanel,stageString,valueString];
    return message;
}

-(void)updateStatusForChanel:(int)chanel value :(NSString *)value{
    NSArray * values = [value componentsSeparatedByString:@","];
    NSLog(@"updateStatusForChanel 1 %f",self.value);
    Boolean isON = [values.lastObject intValue] == 1;
    if (isON) {
        //        id=’WT3-0000000003/1’ cmd=’ON’ value=’W3,2,1’
        if (chanel == 1) {
            //chenal 1
            if (self.value == 0 ||  self.value == 2 ||  self.value == 4 ||  self.value == 6){
                //off
                self.value += 1;
            }else{
//                self.value -= 1;
            }
        }else if (chanel == 2){
            //chenal 2
            if (self.value == 0 || self.value == 1 || self.value == 4 || self.value == 5) {
//
                self.value += 2;
                
            }
        }else if (chanel == 3){
            //chenal 3
            if (self.value < 4) {
                //off
                self.value += 4;
            }
        }
        
    }else{
        if (chanel == 1) {
            //chenal 1
            if (self.value == 1 || self.value == 3 || self.value == 5 || self.value == 7) {
                //on
                self.value -= 1;
            }
        }else if (chanel == 2){
            //chenal 2
            if (self.value == 2 || self.value == 3 || self.value == 6 || self.value == 7) {
                //on
                self.value -= 2;
            }
        }else if (chanel == 3){
            //chenal 3
            if (self.value == 4 || self.value == 5 || self.value == 6 || self.value == 7) {
                //on
                self.value -= 4;
            }
        }
    }
    NSInteger maxPoint = [self maxPoint];
    if (self.value < 0) {
        self.value = 0;
    }else if (self.value > maxPoint){
        self.value = maxPoint;
    }
    NSLog(@"updateStatusForChanel 2 %f",self.value);

}

-(BOOL)isChanelOn:(int)chanel{
    if ([self numberOfSwitchChannel] > 0 && chanel > 0) {
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
-(NSInteger)maxPoint{
    NSInteger numberOfSwitch = [self numberOfSwitchChannel];
    switch (numberOfSwitch) {
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 7;
            break;
        default:
            return 0;
            break;
    }
}
@end
