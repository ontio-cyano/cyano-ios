//
//  CyanoWebView.h
//  cyano
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 LR. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CyanoWebView : UIView <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) void(^callbackPrompt)(NSString *);
@property (nonatomic, copy) void(^callbackJSFinish)(void);

@end
