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
@synthesize isSelected;
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
@end

