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
    }
    return [Utils getTopic];
}
@end
