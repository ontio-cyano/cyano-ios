//
//  RNJsWebView.h
//  cyano
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 LR. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface RNJsWebView : UIView <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) void(^loginCallback)(NSDictionary *);
@property (nonatomic, copy) void(^invokeTransactionCallback)(NSDictionary *);
@property (nonatomic, copy) void(^getAccountCallback)(NSDictionary *);
@property (nonatomic, copy) void(^invokeReadCallback)(NSDictionary *);
@property (nonatomic, copy) void(^invokePasswordFreeCallback)(NSDictionary *);
-(void)setURL:(NSString*)urlString;
-(void)sendMessageToWeb:(NSDictionary*)dic;
@end
