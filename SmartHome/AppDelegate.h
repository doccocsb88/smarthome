//
//  AppDelegate.h
//  SmartHome
//
//  Created by Apple on 3/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (NSString *)fetchBssid;
- (NSString *)fetchSsid;
- (NSDictionary *)fetchNetInfo;
-(void)initData;
@end

