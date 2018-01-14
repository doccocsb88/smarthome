//
//  User.m
//  SmartHome
//
//  Created by Apple on 1/8/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "User.h"

@implementation User
+ (instancetype)sharedInstance
{
    static User *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[User alloc] init];
        // Do any other initialisation stuff here
        
    });
    return sharedInstance;
}
//    accountType = 1;
//    active = 1;
//    displayName = "Anh Hai";
//    email = "anhhai@a.com";
//    passwordShare = 123456;
//    qrCodeUrl = "/v0/b/smarthome-20aeb.appspot.com/o/aajJN4gK0NSfnMdhQfIiGICTmbS2.jpg";
//    sharepassword = "";
//    username = anhhai;
-(void)setData:(FIRDataSnapshot *)snapshot{
    if(snapshot && snapshot.value){
        NSDictionary *info = snapshot.value;
        if (!info) {
            return;
        }
        if([info objectForKey:@"displayName"]){
            self.displayName = [info objectForKey:@"displayName"];
        }
        if([info objectForKey:@"email"]){
            self.email = [info objectForKey:@"email"];
        }
        if([info objectForKey:@"username"]){
            self.username =  [info objectForKey:@"username"];
        }
        if([info objectForKey:@"active"]){
            self.active = [[info objectForKey:@"active"] boolValue];
        }else{
            self.active = false;
        }
        if([info objectForKey:@"accountType"]){
            self.accountType = [[info objectForKey:@"accountType"] intValue];
        }else{
            self.accountType = 0;
        }
        if([info objectForKey:@"node"]){
            self.node = [info objectForKey:@"node"];
        }
        
    }
}
-(void)setDataWithGoogle:(User *)snapshot{
}
-(void)setDevicesData:(FIRDataSnapshot *)snapshot{
    NSDictionary *dict = snapshot.value;
    self.devices = [NSArray new];
    if ([dict objectForKey:@"device"]) {
        NSString *deviceList = [dict objectForKey:@"device"];
        self.devices = [deviceList componentsSeparatedByString:@";"];
    }else{
        self.devices = @"";
    }
}
-(BOOL)isAdmin{
    if (self.accountType == AccountTypeAdmin) {
        return true;
    }
    return false;
}
-(BOOL)isAuthentication{
    if (self.accountType != AccountTypeUnknow) {
        return YES;
    }
    return NO;
}
-(BOOL)canControlDevice:(NSString *)mqttId{
    if (self.accountType == AccountTypeAdmin) {
        return true;
    }else if (self.accountType == AccountTypeMember){
        return [self.devices containsObject:mqttId];
    }
    return false;
}
@end

