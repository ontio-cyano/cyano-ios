//
//  AppDelegate.h
//  Cyano Wallet
//
//  Created by Apple on 2018/12/17.
//  Copyright © 2018 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isNetWorkConnect; //判断network是否连接正常

@end

