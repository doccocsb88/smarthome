//
//  FirebaseHelper.h
//  SmartHome
//
//  Created by Apple on 1/7/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Member.h"
#import "CoredataHelper.h"
#import "MQTTService.h"
#import "Utils.h"
@import Firebase;
@import FirebaseAuth;
typedef enum LoginType : NSUInteger {
    LoginTypeFacebook,
    LoginTypeGoogle
} LoginType;
@interface FirebaseHelper : NSObject
typedef void (^FirebaseLoginCallback)(FIRUser * user);
typedef void (^FirebaseMemberCallback)(NSArray * members);
typedef void (^FirebaseCallback)(BOOL exist);

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRUser *user;
@property (assign, nonatomic) LoginType loginType;
+ (instancetype)sharedInstance;
-(void)logout;
-(void)loginDemo:(nullable FirebaseLoginCallback)completion;
-(void)loginWithCredential:(nullable FIRAuthCredential *)credential loginType:(LoginType)loginType completion:(nullable FirebaseLoginCallback)completion;
-(void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(nullable FirebaseLoginCallback)completion;
-(NSString *)getUid;
-(BOOL)isLogin;
-(BOOL)isAdmin;
-(void)getProfileInfo;
-(void)synMemberList:(nullable FirebaseMemberCallback)completion;
-(void)shareDevice:(NSString *)mqttId forUser:(NSString *)key;
-(void)addRoom:(Room *)room;
-(void)updateRoom:(Room *)room;
//
-(void)addScene:(Scene *)scene;
//
-(void)addSceneDetail:(SceneDetail *)sceneDetail sceneId:(NSInteger )sceneId;
-(void)updateSceneDetail:(SceneDetail *)sceneDetail sceneId:(NSInteger )sceneId;
-(void)addDevice:(Device *)device roomId:(NSInteger)roomId;
-(void)updateDevice:(Device *)device roomId:(NSInteger)roomId;
//
-(void)addTimer:(SHTimer *)timer deviceId:(NSInteger)deviceId;
-(void)addDeviceToSystem:(NSString *)mqttId;
-(void)delleteDevice:(NSString *)mqttId;
-(void)delleteDeviceInSystem:(NSString *)mqttId;
-(void)hasDeviceInSystem:(NSString *)mqttId completion:(nullable FirebaseCallback)completion;
-(void)clearData;
-(void)requestMember:(NSString *)adminUid completion:(nullable FirebaseCallback)completion;;
@end

