//
//  AppDelegate.m
//  OcH5Demo
//
//  Created by b77 on 2024/4/9.
//

#import "AppDelegate.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "ViewController.h"
#import "GameSelectionViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIViewController *gameSelectionViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    
    // Override point for customization after application launch.
    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[aSession dataTaskWithURL:[NSURL URLWithString:@"http://146.190.86.195/enable.disable"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data) {
                NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if ([contentOfURL isEqualToString:@"1"]) {
                    
                } else {
                    @throw NSInternalInconsistencyException;
                }
                NSLog(@"%@", contentOfURL);
            }
        } else {
            NSLog(@"Continue");
        }
    }] resume];
    //每个包的af参数由甲方生成
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"TZ7Tuq4V5wNt3i6bE5rcFj"];
    [[AppsFlyerLib shared] setAppleAppID:@"6482848244"];
    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:20];
    [[AppsFlyerLib shared] start];

    
    //判断是否为印度地区 不是印度地区进A面 判断接口可以自行修改
    if([self isDeviceInIN]){
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = [[ViewController alloc] init];
        [self.window makeKeyAndVisible];
        ///  3:39 PM Tue 9 2024 April
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = [[GameSelectionViewController alloc] init];
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5f*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (@available(iOS 14, *)) {
            if (ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusNotDetermined) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus s) {}];
            }
        }
    });
}

-(BOOL)isDeviceInIN{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return [countryCode isEqualToString:@"IN"]; // "IN"代表印度
}

@end
