//
//  Scene.m
//  SmartHome
//
//  Created by Apple on 4/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "Scene.h"
#import "Utils.h"
@implementation Scene
@dynamic order;
@dynamic sceneDetail;
-(CGFloat)getLoadingTime{
    NSInteger count = 0;
    for (SceneDetail *dv in [self.sceneDetail allObjects]) {
        if ([Utils getDeviceType:dv.device.topic] == DeviceTypeLightOnOff) {
            count++;
        }
    }
    return count * 0.5;
}

@end
