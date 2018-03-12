//
//  MQTTService.m
//  SmartHome
//
//  Created by Ngoc Truong on 7/15/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "MQTTService.h"
#import "Utils.h"
#import "NSString+Utils.h"
#import "FirebaseHelper.h"
#define CHECK_PUBLISH_TIME 2
#define REQUEST_STATUS_TIME 0.5
static MQTTService *instance = nil;

@interface MQTTService() <MQTTSessionDelegate>
@property (assign, nonatomic) NSInteger countProcess;
@end
@implementation MQTTService
+ (instancetype)sharedInstance
{
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[MQTTService alloc] _init];
        });
    }
 
    return instance;
}

//- (instancetype)init {
//    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"..." userInfo:nil];
//}
- (instancetype)_init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setUP];
    return self;
}

- (void)setUP {
    if (_isInit == false) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kMqttConnectToServer" object:nil userInfo:@{@"result":@"0"}];
        MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
        transport.host = @"quocanhtest.dyndns.tv";
        transport.port = 1883;
//        transport.sho
        _session = [[MQTTSession alloc] init];
        _session.transport = transport;
        _session.keepAliveInterval = 120;
        _session.delegate = self;
        _isConnecting = true;
        [_session connectAndWaitTimeout:30];
        NSLog(@"aabbccddeeff");
        //
        self.publishedTopic = [[NSMutableArray alloc] init];
        self.publishingTopic = [[NSMutableArray alloc] init];
        _isInit = true;
    }

   
}
-(void)removeListDevices:(NSArray *)devices{
    NSArray *arr = [self.dataArray copy];
    for (Device *device in devices) {
        for (Device *d in arr) {
            if (device.id == d.id) {
                [self.dataArray removeObject:d];
                NSString *topic = @"";
                
                if (device.type == DeviceTypeCurtain) {
                    topic = [NSString stringWithFormat:@"%@/FEEDBACK",device.requestId];
                    
                    
                }else if (device.type == DeviceTypeLightOnOff){
                    topic = [NSString stringWithFormat:@"%@", [Utils getTopic]];
                    
                    
                }
                if (topic && topic.length > 0) {
                    [_session unsubscribeTopic:topic unsubscribeHandler:^(NSError *error) {
                        
                    }];
                }
               
            }
        }
    }
}
-(void)setListDevices:(NSArray *)devices{
    self.countProcess = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (!self.dataArray) {
            self.dataArray = [[NSMutableArray alloc] init];
        }
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:devices];
        for (Device *dv in devices) {
            for (Device *dc in self.dataArray) {
                if (dc.id == dv.id) {
                    [arr removeObject:dv];
                }
            }
            
        }
        [self.dataArray addObjectsFromArray:arr];
        NSMutableArray *arrCopy = [self.dataArray copy];
        NSInteger index = 1;
        for (Device *device in arrCopy) {
            NSString *topic = @"";
            
            if (device.type == DeviceTypeCurtain || device.type == DeviceTypeTouchSwitch) {
                topic = [device getTopic];
                
                
            }else if (device.type == DeviceTypeLightOnOff){
                topic = [Utils getTopic];
                
                
            }
            __weak MQTTService *wsekf = self;
            if ([self.publishedTopic containsObject:topic] == false) {
                if (topic && topic.length > 0) {
                    [wsekf.publishedTopic addObject:topic];
                    self.countProcess ++;
                    [_session subscribeToTopic:topic atLevel:1 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss){
                        if (error) {
                            NSLog(@"Subscription failed %@", error.localizedDescription);
                        } else {
                            NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
                            self.countProcess --;
                            [self checkFinishedProcess];
                            device.isSubcrible = TRUE;
                            double delayInSeconds = 0;
                            delayInSeconds  = index * REQUEST_STATUS_TIME;
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                //code to be executed on the main queue after delay
                                [wsekf publicRequestStatus:device.requestId];
                            });

                        }
                    }]; // t
                }
            }else{
                if (topic && topic.length > 0) {
                    if ([topic isEqualToString:[Utils getTopic]]) {
                        self.countProcess ++;
                        
                        double delayInSeconds = 0;
                        if ([Utils getDeviceType:topic] == DeviceTypeLightOnOff) {
                            delayInSeconds  = index * REQUEST_STATUS_TIME;

                        }
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [self publicRequestStatus:device.requestId];
                        });

                    }
                
                }
            }
            if ([Utils getDeviceType:topic] == DeviceTypeLightOnOff ) {
                index ++;
            }
            
        }
    });
}
-(void)clearPublishDevice{
    self.publishedTopic = [NSMutableArray new];
}
-(Device *)getDeviceByTopic:(NSString *)topic{
    for (Device *device in self.dataArray) {
        if (device.type == DeviceTypeCurtain || device.type == DeviceTypeTouchSwitch) {
            if ([topic containsString:device.requestId]) {
                return device;
            }
        }else if (device.type == DeviceTypeLightOnOff){
            if ([topic isEqualToString:device.requestId]) {
                return device;
            }
        }
        
    }
    return nil;
}

-(void)publicRequestStatus:(NSString *)topic{
    Device *device = [self getDeviceByTopic:topic];
    if (device && device.isGetStatus == false) {
        NSString *msg = @"";
        NSString *topic = @"";
        if (device.type == DeviceTypeCurtain || device.type == DeviceTypeTouchSwitch) {
          msg = [NSString stringWithFormat:@"id='%@' cmd='GETSTATUS'",device.requestId];
        topic = [device getTopic];
//            [_session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:[device getTopic] retain:NO qos:2 publishHandler:^(NSError *error) {
//                self.countProcess--;
//                [self checkFinishedProcess];
//
//            }];

        }else if(device.type == DeviceTypeLightOnOff){
            msg = [NSString stringWithFormat:@"id='%@' cmd='GETSTATUS'",device.requestId];
            topic = [Utils getTopic];
            NSLog(@"requestStatus: %@",msg);
  
           
        }
        NSLog(@"MQTTService : %@",topic);
        [_session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:topic retain:false qos:2 publishHandler:^(NSError *error) {
            self.countProcess--;
            [self checkFinishedProcess];
        }];
        
    }
}

-(void)publishControl:(NSString *)topic message:(NSString *)message type:(NSInteger)type count:(int)count{
    if ([self.publishingTopic containsObject:topic]) {
        return;
    }
    NSLog(@"publishControl xxx %@",topic);
    if (type == DeviceTypeCurtain) {
        NSString *msg = [NSString stringWithFormat:@"id='%@' cmd='%@'",topic,message];
        if ([message containsString:@"value"]) {
           msg = message;
        }

    
        [self.publishingTopic addObject:topic];
        [NSTimer scheduledTimerWithTimeInterval:CHECK_PUBLISH_TIME target:self selector:@selector(checkPublishSucess:) userInfo:@{@"topic":topic,@"message":message,@"type":[NSString stringWithFormat:@"%ld",type],@"count":[NSString stringWithFormat:@"%d",count]} repeats:NO];
        [_session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:[NSString stringWithFormat:@"QA_CC_%@",topic] retain:NO qos:2 publishHandler:^(NSError *error) {

        }];
    }else if (type == DeviceTypeTouchSwitch){
       
        [self.publishingTopic addObject:topic];
        [NSTimer scheduledTimerWithTimeInterval:CHECK_PUBLISH_TIME target:self selector:@selector(checkPublishSucess:) userInfo:@{@"topic":topic,@"message":message,@"type":[NSString stringWithFormat:@"%ld",type],@"count":[NSString stringWithFormat:@"%d",count]} repeats:NO];
        NSLog(@"tư : 3 %@",message);

        [_session publishData:[message dataUsingEncoding:NSUTF8StringEncoding] onTopic:topic retain:NO qos:2 publishHandler:^(NSError *error) {
            
        }];
    }else if (type == DeviceTypeLightOnOff){
        NSString *msg = @"";
        if ([message isEqualToString:@"CLOSE"]) {
            msg = [NSString stringWithFormat:@"id='%@' cmd='OFF'",topic];
        }else if ([message isEqualToString:@"OPEN"]){
            msg = [NSString stringWithFormat:@"id='%@' cmd='ON'",topic];
            
        }
        if (msg && msg.length > 0) {
            [self.publishingTopic addObject:topic];
            [NSTimer scheduledTimerWithTimeInterval:CHECK_PUBLISH_TIME target:self selector:@selector(checkPublishSucess:) userInfo:@{@"topic":topic,@"message":message,@"type":[NSString stringWithFormat:@"%ld",type],@"count":[NSString stringWithFormat:@"%d",count]} repeats:NO];

            [_session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:[Utils getTopic
                                                                                        ] retain:NO qos:2 publishHandler:^(NSError *error) {

                if (error) {
                    NSLog(@"publish failed");
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
                        [self.delegate mqttPublishFail];
                    }
                }
            }];
        }
        
    }
    
}
-(void)requestStatusTimer:(NSArray *)arrTimer{
    NSInteger index = 0;
    for (SHTimer *timer in arrTimer) {
        double delayInSeconds = index * 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSString *msg = [timer getStatusCommandString];
            [_session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:timer.topic retain:NO qos:2 publishHandler:^(NSError *error) {
                
                if (error) {
                    NSLog(@"publish failed");
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
                        [self.delegate mqttPublishFail];
                    }
                }
            }];
        });
        index ++;
    }
    
}
-(void) setTimer:(SHTimer *)timer{
    NSString *msg = [timer getCommandString:DeviceTypeUnknow goto:timer.isSlide];

    [_session publishData:[msg dataUsingEncoding:NSUTF8StringEncoding] onTopic:timer.topic retain:NO qos:2 publishHandler:^(NSError *error) {
        
        if (error) {
            NSLog(@"publish failed");
            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
                [self.delegate mqttPublishFail];
            }
        }
    }];
}

-(void)addMQTTDevice:(Device *)device{
    [_session publishData:[[device getAddMessage] dataUsingEncoding:NSUTF8StringEncoding] onTopic:device.topic retain:NO qos:2 publishHandler:^(NSError *error) {
        
        if (error) {
            NSLog(@"publish failed");
            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
                [self.delegate mqttPublishFail];
            }
        }
    }];

}
-(void)delMQTTDevice:(Device *)device{
    [_session publishData:[[device getDelMessage] dataUsingEncoding:NSUTF8StringEncoding] onTopic:device.topic retain:NO qos:2 publishHandler:^(NSError *error) {
        
        if (error) {
            NSLog(@"publish failed");
            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
                [self.delegate mqttPublishFail];
            }
        }
    }];
    
}

-(void)checkPublishSucess:(NSTimer *)timer{
    NSDictionary *userInfo = timer.userInfo;
    for (NSString *str in self.publishingTopic) {
        NSLog(@"checkPublishSucess : %@",str);

    }
    if (userInfo) {
        NSString *topic = [userInfo objectForKey:@"topic"];
        if (topic) {
            if ([self.publishingTopic containsObject:topic]) {
                NSString *message = [userInfo objectForKey:@"message"];
                NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
                int count  = [[userInfo objectForKey:@"count"] intValue];
                NSLog(@"publish failed message");
                [self.publishingTopic removeObject:topic];
                if (count < 3) {
                    count = count + 1;
                    [self publishControl:topic message:message type:type count:count];

                }else{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
                        [self.delegate mqttPublishFail];
                    }
                }
            }else{
                NSLog(@"publish cmn roi");
            }
        }
    }
}
-(void)turnOffAllDevice:(NSString *)topic message:(NSString *)message type:(NSInteger)type{

}

-(void)checkFinishedProcess{
    if (self.countProcess == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mqttFinishedProcess)]) {
            [self.delegate mqttFinishedProcess];
        }
    }
}
-(BOOL)isConnected{
    return _isConnect;
}

-(void)connected:(MQTTSession *)session{
    NSLog(@"connected");
    _isConnect = true;
    _isConnecting = false;

    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttConnected)]) {
        [self.delegate mqttConnected];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"kMqttConnectToServer" object:nil userInfo:@{@"result":@"1"}];
}

-(void)connectionClosed:(MQTTSession *)session{
    NSLog(@"connectionClosed");
    _isConnect = false;
    _isConnecting = false;

    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    if (self.publishedTopic) {
        [self.publishedTopic removeAllObjects];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttDisConnect)]) {
        [self.delegate mqttDisConnect];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"kMqttConnectToServer" object:nil userInfo:@{@"result":@"4"}];
}

-(void)connectionError:(MQTTSession *)session error:(NSError *)error{
    NSLog(@"connectionError %@",error.description);
    _isConnect = false;
    _isConnecting = false;

    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    if (self.publishedTopic) {
        [self.publishedTopic removeAllObjects];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttDisConnect)]) {
        [self.delegate mqttDisConnect];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMqttConnectToServer" object:nil userInfo:@{@"result":@"3"}];
}

-(void)connectionRefused:(MQTTSession *)session error:(NSError *)error{
    NSLog(@"connectionRefused");
    _isConnect = false;
    _isConnecting = false;

    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    if (self.publishedTopic) {
        [self.publishedTopic removeAllObjects];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttDisConnect)]) {
        [self.delegate mqttDisConnect];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"kMqttConnectToServer" object:nil userInfo:@{@"result":@"2"}];
}

-(void)connected:(MQTTSession *)session sessionPresent:(BOOL)sessionPresent{
    NSLog(@"connected sessionPresent %d",sessionPresent);
    _isConnect = true;
    _isConnecting = false;

    if (self.delegate && [self.delegate respondsToSelector:@selector(mqttConnected)]) {
        [self.delegate mqttConnected];
    }
 [[NSNotificationCenter defaultCenter] postNotificationName:@"kMqttConnectToServer" object:nil userInfo:@{@"result":@"1"}];
}
- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid {
    // this is one of the delegate callbacks
    NSString *message = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
    NSLog(@"newMessage %@: %@",topic,message);
    BOOL isValue = false;
    if ([message isNumber]) {
        if ([Utils getDeviceType:topic] == DeviceTypeCurtain) {
            [self.publishingTopic removeObject:topic];
            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttSetStateValueForDevice:value:)]) {
                isValue = true;
                [self.delegate mqttSetStateValueForDevice:topic value:[message floatValue]];
            }
        }
    }else{
        if([Utils getDeviceType:topic] == DeviceTypeLightOnOff || [Utils getDeviceType:topic] == DeviceTypeCurtain || [Utils getDeviceType:topic] == DeviceTypeTouchSwitch){
            if ([message containsString:@"TIMERSTATUS"]) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(mqttSetStateValueForTimer:)]) {
                    [self.delegate mqttSetStateValueForTimer:message];
                }

            }else if ([message containsString:@"STATUS"]){
                    
                    NSArray *tmp = [message componentsSeparatedByString:@"'"];
                    if (tmp.count > 5) {
                        NSString *value = tmp[5];
                    
                        if ([value isEqualToString:@"1,2,0"] || [value isEqualToString:@"1,2,1"]) {
                            //den
                            [self.publishingTopic removeObject:tmp[1]];
                            Device *getStatusDevice = [self getDeviceByTopic:tmp[1]];
                            if (getStatusDevice) {
                                if ([value isEqualToString:@"1,2,1"]) {
                                    getStatusDevice.state = NO;
                                }else if([value isEqualToString:@"1,2,0"]){
                                    getStatusDevice.state = YES;
                                    
                                }
                                getStatusDevice.isGetStatus = true;
                                [[CoredataHelper sharedInstance] save];
                            }
                            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttSetStateValueForLight:)]) {
                                isValue = true;
                                [self.delegate mqttSetStateValueForLight:message];
                                
                            }
                        }else if ([value containsString:@"W"]){
                            //touch switch
                            if([tmp[1] containsString:@"/"]){
                                NSString *topic = [tmp[1] componentsSeparatedByString:@"/"].firstObject;
                                NSString *chanel = [tmp[1] componentsSeparatedByString:@"/"].lastObject;
                                
                                [self.publishingTopic removeObject:topic];
                                Device *getStatusDevice = [self getDeviceByTopic:topic];

                               
                                if (getStatusDevice) {
                                    if (chanel.length > 0 && [chanel isNumber]) {
                                        int numberIndex = [chanel intValue];
                                        [getStatusDevice updateStatusForChanel:numberIndex value:value];
                                        
                                    }
                                    getStatusDevice.isGetStatus = true;
                                    [[CoredataHelper sharedInstance] save];
                                }
                            }
                            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttSetStateValueForLight:)]) {
                                [self.delegate mqttSetStateValueForLight:message];
                            }
                        }else if([value isNumber])
                        {
                            [self.publishingTopic removeObject:tmp[1]];
                            Device *getStatusDevice = [self getDeviceByTopic:tmp[1]];
                            if (getStatusDevice) {
                                getStatusDevice.isGetStatus = true;
                                getStatusDevice.value = [value floatValue];
                                [[CoredataHelper sharedInstance] save];
                            }
                            if (self.delegate && [self.delegate respondsToSelector:@selector(mqttSetStateValueForLight:)]) {
                                [self.delegate mqttSetStateValueForLight:message];
                            }
                            
                        }
                    }else{
                        //device is not respne
                   
                            Device *getStatusDevice = [self getDeviceByTopic:tmp[1]];
                            if (getStatusDevice) {
                                getStatusDevice.isGetStatus = true;
                                [[CoredataHelper sharedInstance] save];
                            }
                        
                            
                        
                    }
                    
                    
                
            }else if ([message containsString:@"ADD"]){
                if (self.delegate && [self.delegate respondsToSelector:@selector(mqttAddSuccess)]) {
                    [self.delegate mqttAddSuccess];
                }
            }else if ([message containsString:@"DELOK"]){
                // id=‘xxxx’ cmd=‘DELOK’
                if (self.delegate && [self.delegate respondsToSelector:@selector(mqttDelSuccess)]) {
                    NSArray *tmp = [message componentsSeparatedByString:@"'"];
                    NSString *mqttId = tmp[1];
                    if (mqttId && mqttId.length > 0) {
                        [[FirebaseHelper sharedInstance] delleteDevice:mqttId];
                        [[FirebaseHelper  sharedInstance] delleteDeviceInSystem:mqttId];
                    }
                    if ([tmp containsObject:@"DELOK"]) {
                        [self.delegate mqttDelSuccess];
                    }
                }

            }
        }
    }
    if (!isValue) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mqttPublishFail)]) {
            isValue = true;
//            [self.delegate mqttPublishFail];
        }
    }
}

@end
