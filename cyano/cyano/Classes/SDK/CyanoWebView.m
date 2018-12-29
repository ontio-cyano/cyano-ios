//
//  CyanoWebView.m
//  cyano
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 LR. All rights reserved.
//

#import "CyanoWebView.h"


@implementation CyanoWebView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.wkWebView];
        
    }
    return self;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.preferences = [WKPreferences new];
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.preferences.javaScriptEnabled = YES;
        
        configuration.userContentController = [[WKUserContentController alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"getWalletDataStr"];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.frame configuration:configuration];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        NSString *webPath = [[NSBundle mainBundle] pathForResource:@"js" ofType:nil];
        [_wkWebView loadFileURL:[NSURL fileURLWithPath:[webPath stringByAppendingPathComponent:@"Cyano.html"]] allowingReadAccessToURL:[NSURL fileURLWithPath:webPath]];
        
        
    }
    return _wkWebView;
}


#pragma mark WKWebViewDelegate
/**
 webview加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (_callbackJSFinish) {
        _callbackJSFinish();
        
    }
}

/**
 webview开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}
/**
 webview拦截alert
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
}

/**
 webview拦截Confirm
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    completionHandler(YES);
}

/**
 webview拦截Prompt
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    [self savePrompt:prompt];
    completionHandler(@"123");
}

/**
 webview拦截js方法
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
}

#pragma mark handlePrompt
- (void)savePrompt:(NSString *)prompt {
    _callbackPrompt(prompt);
    if ([prompt hasPrefix:@"Ont://"]) {
        
        NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
        NSString *resultStr = promptArray[1];
        id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        prompt = [prompt substringFromIndex:6];
        _callbackPrompt(prompt);
        
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            
        }else{
            
            if ([[obj valueForKey:@"error"] integerValue] == 52000) {
                
                return;
            }
            
            if ([[obj valueForKey:@"error"] integerValue] == 53000) {
                return;
            }
        }
        
    }
    
}


@end









