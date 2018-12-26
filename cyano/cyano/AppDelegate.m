//
//  AppDelegate.m
//  cyano
//
//  Created by Apple on 2018/12/17.
//  Copyright © 2018 LR. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 监测网络情况
    [self monitorNetWorkStatus];
    
    //获取参数配置
    [self getConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController* vc = [[MainViewController alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    //JS初始化
    _browserView = self.browserView;
    return YES;
}

- (void)monitorNetWorkStatus {
    //监测方法
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //无网络通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NONNETNOTIFICATION object:nil];
            _isNetWorkConnect = NO;
        } else {
            //有网络通知
            [[NSNotificationCenter defaultCenter] postNotificationName:GETNETNOTIFICATION object:nil];
            _isNetWorkConnect = YES;
            
        }
    }];
    
}
- (void)getConfig {
    
    NSString *urlStr = Ongamount_query;
    [[CCRequest shareInstance]
     requestWithURLStringNoLoading:urlStr MethodType:MethodTypeGET Params:nil Success:^(id responseObject,
                                                                                        id responseOriginal) {
         [MBProgressHUD hideHUDForView:self.window animated:YES];
         [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%lf",
                                                          [[responseObject valueForKey:@"Fee"]
                                                           doubleValue]
                                                          / 1000000000] forKey:FEE];
         [[NSUserDefaults standardUserDefaults]
          setValue:[NSString stringWithFormat:@"%@", [responseObject valueForKey:@"LoginTimeout"]] forKey:LOGOUTTIME];
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"TestnetAddr"] forKey:TESTNETADDR];
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"OntPassAddr"] forKey:ONTPASSADDRSS];
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"NetName"] forKey:NETNAME];
         
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"DragonCodeHash"] forKey:DRAGONCODEHASH];
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"GetDragonListUrl"] forKey:DRAGONLISTURL];
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"PreActionNetAddr"] forKey:PRENODE];
         
         
         [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"mobile"];
         [[NSUserDefaults standardUserDefaults]
          setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_price"] forKey:ONTIDGASPRICE];
         [[NSUserDefaults standardUserDefaults]
          setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_limit"] forKey:ONTIDGASLIMIT];
         [[NSUserDefaults standardUserDefaults]
          setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_price"] forKey:ASSETGASPRICE];
         [[NSUserDefaults standardUserDefaults]
          setValue:[[responseObject valueForKey:@"OntIdContract"] valueForKey:@"gas_limit"] forKey:ASSETGASLIMIT];
         
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"GasPriceMax"] forKey:GASPRICEMAX];
         [[NSUserDefaults standardUserDefaults]
          setBool:[responseObject valueForKey:@"IsClaimOngSelfPay"] ? YES : NO forKey:ISONGSELFPAY];
         
         [[NSUserDefaults standardUserDefaults]
          setValue:[responseObject valueForKey:@"MinClaimableOng"] forKey:MINCLAIMABLEONG];
         [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"MinUnboundOng"] forKey:MINUNBOUNDONG];
     }Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
         [MBProgressHUD hideHUDForView:self.window animated:YES];
     }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [Common deleteEncryptedContent:ASSET_ACCOUNT];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        LOADJS1;
        LOADJS2;
        LOADJS3;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            DebugLog(@"prompt=%@", prompt);
        }];
        [_browserView setCallbackJSFinish:^{
            
        }];
    }
    return _browserView;
}
@end
