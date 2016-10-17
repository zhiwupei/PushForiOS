//
//  AppDelegate+Push.m
//  SeekStar
//
//  Created by 植梧培 on 16/10/17.
//  Copyright © 2016年 模特. All rights reserved.
//

#import "AppDelegate+Push.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate (Push)
- (void)registerNotification {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kMessagePushKey]) {
        return;
    }
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                //                NSLog(@"注册推送succeeded!");
                //                NSLog(@"get push %zd",granted);
                //                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                //                    NSLog(@"%@",settings);
                //                }];
            }
        }];
        
        
        
#endif
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //    NSLog(@"怎么不走");
    TIMTokenParam * param = [[TIMTokenParam alloc] init];
    [param setToken:deviceToken];
#ifdef DEBUG
    param.busiId = 2525;
#else
    param.busiId = 2526;
    
#endif
    NSInteger result = [[TIMManager sharedInstance] setToken:param];
    NSLog(@"上传token 结果%zd",result);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    //    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"%@",notification);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"%@",response);
}

#endif





@end
