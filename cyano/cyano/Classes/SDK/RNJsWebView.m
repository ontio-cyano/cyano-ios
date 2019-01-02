//
//  RNJsWebView.m
//  cyano
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 LR. All rights reserved.
//

#import "RNJsWebView.h"

@implementation RNJsWebView


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
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc]init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.userContentController = [[WKUserContentController alloc]init];
        config.processPool = [[WKProcessPool alloc]init];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.frame configuration:config];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        
    }
    return _wkWebView;
}

-(void)setURL:(NSString *)urlString{
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: urlString]]];
}
- (void)setupPostMessageScript {
    
    NSString *source = @"window.originalPostMessage = window.postMessage;"
    "window.postMessage = function(message, targetOrigin, transfer) {"
    "window.webkit.messageHandlers.JSCallback.postMessage(message);"
    "if (typeof targetOrigin !== 'undefined') {"
    "window.originalPostMessage(message, targetOrigin, transfer);"
    "}"
    "};";
    
    
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                               forMainFrameOnly:false];
    [_wkWebView.configuration.userContentController addUserScript:script];
    [_wkWebView evaluateJavaScript:source completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    
}
- (void)postMessage:(NSString *)message
{
    NSDictionary *eventInitDict = @{
                                    @"data": message,
                                    };
    NSString *source = [NSString
                        stringWithFormat:@"document.dispatchEvent(new MessageEvent('message', %@));",
                        [self dictionaryToJson:eventInitDict]
                        ];
    
    
    [_wkWebView evaluateJavaScript:source completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

-(void)sendMessageToWeb:(NSDictionary *)dic{
    NSString * jsonString = [self dictionaryToJson:dic];
    NSString *encodedURL = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *base64String = [self base64EncodeString:encodedURL];
    NSString *jsStr = [NSString stringWithFormat:@"%@",base64String ];
    [self postMessage:jsStr];
}
#pragma mark WKWebViewDelegate
/**
 webview加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self setupPostMessageScript];
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
    completionHandler(@"123");
}

/**
 webview拦截js方法
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"JSCallback"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            return;
        }
        [self handleMessage:message.body];
    }
}

#pragma mark handleMessage
// DApp 网页回调处理
- (void)handleMessage:(NSString *)prompt {
    if (![prompt containsString:@"params="]) {
        return;
    }
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    NSString *base64decodeString = [self stringEncodeBase64:resultStr];
    NSDictionary *resultDic = [self dictionaryWithJsonString:[base64decodeString stringByRemovingPercentEncoding]];
    if (resultDic[@"action"]) {
        if ([resultDic[@"action"] isEqualToString:@"login"]) {
            if (_loginCallback) {
                _loginCallback(resultDic);
            }
        }else if ([resultDic[@"action"] isEqualToString:@"invoke"]){
            if (_invokeTransactionCallback) {
                _invokeTransactionCallback(resultDic);
            }
        }else if ([resultDic[@"action"] isEqualToString:@"getAccount"]){
            if (_getAccountCallback) {
                _getAccountCallback(resultDic);
            }
        }else if ([resultDic[@"action"] isEqualToString:@"invokeRead"]){
            if (_invokeReadCallback) {
                _invokeReadCallback(resultDic);
            }
        }else if ([resultDic[@"action"] isEqualToString:@"invokePasswordFree"]){
            if (_invokePasswordFreeCallback) {
                _invokePasswordFreeCallback(resultDic);
            }
        }
    }
}

- (NSString *)stringEncodeBase64:(NSString *)base64 {
    
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    
    NSString *base64Decoded = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
    return base64Decoded;
    
}

- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData
    *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonDataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonDataStrWithoutEscape = [jsonDataStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonDataStrWithoutEscape;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary
    *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return dic;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
- (NSString *)base64EncodeString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
    
}
@end









