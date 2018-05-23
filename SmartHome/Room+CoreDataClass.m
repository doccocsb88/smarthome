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
-(NSInteger)countDevices{
    NSInteger numberOfDevice = 0;
    for(Device *device in [self.devices allObjects]){
        if (device.type == DeviceTypeTouchSwitch) {
            numberOfDevice += [device numberOfSwitchChannel];
        }else{
            numberOfDevice += 1;
        }
    }
    
    return numberOfDevice;
}
-(NSArray *)getDeviceForShared{
    NSMutableArray *shareDevices = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order"
                                                 ascending:NO];
    NSArray *sortedDeviceArray = [[self.devices allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];

    for(Device *device in sortedDeviceArray){
        if (device.type == DeviceTypeTouchSwitch) {
            for (int i = 0; i < [device numberOfSwitchChannel]; i++) {
                int chanelIndex = i + 1;

                ShareDevice *dv =  [[ShareDevice alloc] init];
                dv.mqttId = [NSString stringWithFormat:@"%@/%d",device.requestId,chanelIndex];
                dv.name = [device getChanelName:chanelIndex];
                [shareDevices addObject:dv];
            }
        }else{
            ShareDevice *dv =  [[ShareDevice alloc] init];
            dv.mqttId = device.requestId;
          
            dv.name = device.name;
            [shareDevices addObject:dv];
        }
    }
    return shareDevices;
}

@end
