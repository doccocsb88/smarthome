//
//  Room+CoreDataClass.m
//  
//
//  Created by Ngoc Truong on 7/17/17.
//
//

#import "Room+CoreDataClass.h"
#import "Device.h"
#import "SceneDetail.h"
@implementation Room
-(NSInteger)countAutocontrolDevice{
    NSInteger count = 0;
    for(Device *device in [self.devices allObjects]){
        if ([device numberOfSwitchChannel] > 0) {
            count += [device numberOfSwitchChannel];
        }else{
            count += 1;
        }
        
    }
    return count;
}
-(BOOL)hasDevice:(NSString *)mqttId{
    for(Device *device in [self.devices allObjects]){
        if ([device.requestId isEqualToString:mqttId]){
            return true;
        }
    }
    return false;

}
@end
