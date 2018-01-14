//
//  MQTTService.h
//  SmartHome
//
//  Created by Ngoc Truong on 7/15/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTClient.h"
#import "Utils.h"
#import "Device.h"
#import "SHTimer+CoreDataClass.h"
@protocol MQTTServiceDelegate <NSObject>

//            [self setStateValueForDevice:topic value:[message floatValue]];
//            [self setStateValueForLight:message];
@optional
-(void)mqttSetStateValueForDevice:(NSString *)topic value:(float) value;
-(void)mqttSetStateValueForLight:(NSString *)message;
-(void)mqttSetStateValueForTimer:(NSString *)message;
-(void)mqttAddSuccess;
-(void)mqttAddFailed;
-(void)mqttDelSuccess;
-(void)mqttDelFailed;

-(void)mqttPublishFail;

-(void)mqttConnected;
-(void)mqttDisConnect;
-(void)mqttFinishedProcess;

@end
@interface MQTTService : NSObject
+ (instancetype)sharedInstance;
@property (assign, nonatomic) BOOL isInit;
@property (assign, nonatomic) BOOL isConnect;
@property (assign, nonatomic) BOOL isConnecting;

@property (strong, nonatomic) id<MQTTServiceDelegate> delegate;
@property (strong, nonatomic) MQTTSession *session;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *publishedTopic;
@property (strong, nonatomic) NSMutableArray *publishingTopic;

-(BOOL)isConnected;
-(void)removeListDevices:(NSArray *)devices;
-(void)setListDevices:(NSArray *)devices;
-(void)publishControl:(NSString *)topic message:(NSString *)message type:(NSInteger)type count:(int)count;
-(void)publicRequestStatus:(NSString *)topic;
-(void)requestStatusTimer:(NSArray *)arrTimer;
-(void)setTimer:(SHTimer *)timer;
-(void)turnOffAllDevice:(NSString *)topic message:(NSString *)message type:(NSInteger)type;
-(void)addMQTTDevice:(Device *)device;
-(void)delMQTTDevice:(Device *)device;
-(void)clearPublishDevice;

@end
