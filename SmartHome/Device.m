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
@synthesize key;
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
@end
