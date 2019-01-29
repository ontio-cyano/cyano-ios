//
//  ONTIdWebView.h
//  cyano
//
//  Created by Apple on 2019/1/22.
//  Copyright © 2019 LR. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface ONTIdWebView : UIView <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) void(^authenticationCallback)(NSDictionary *);
@property (nonatomic, copy) void(^authorizationCallback)(NSDictionary *);
@property (nonatomic, copy) void(^getIdentityCallback)(NSDictionary *);
-(void)setURL:(NSString*)urlString;
-(void)sendMessageToWeb:(NSDictionary*)dic;
@end
