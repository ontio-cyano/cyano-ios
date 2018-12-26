//
//  CeshiViewController.m
//  cyano
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018 LR. All rights reserved.
//

#import "DAppViewController.h"
#import <WebKit/WebKit.h>
#import "Common.h"
#import "SendConfirmView.h"
#import "BrowserView.h"
#import "InfoAlert.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface DAppViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    WKWebView      *webView;
    UIButton       *promptButton;
    NSString       *resultString;
}
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) SendConfirmView *sendConfirmV;
@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic, copy)   NSString *confirmPwd;
@property(nonatomic, copy)   NSString       *hashString;
@property(nonatomic, strong) MBProgressHUD *hub;
@property(nonatomic, assign) BOOL isLogin;
@property(nonatomic, strong) NSDictionary   *promptDic;
@property(nonatomic,strong)UIWindow         *window;
@end

@implementation DAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    self.isLogin = YES;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.isNetWorkConnect == NO) {
        [Common showToast:@"Network error"];
    } else {
        [self loadWeb];
    }
    
    self.progressView =
    [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.progressView.backgroundColor = MainColor;
    self.progressView.tintColor = [UIColor colorWithHexString:@"#35BFDF"];
    
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"JSCallback"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            }                completion:^(BOOL finished) {
                
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
        }];
    }
    return _browserView;
}
- (void)configUI {
    
    [self.view addSubview:self.browserView];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc]init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.userContentController = [[WKUserContentController alloc]init];
    config.processPool = [[WKProcessPool alloc]init];
    webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];

    
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

// 导航栏设置
- (void)configNav {
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:@""];
    
}

// 返回
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 加载网页
- (void)loadWeb {
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_dAppDic[@"link"]]]];
    
}

//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char *) bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

#pragma mark WKWebViewDelegate
/**
 webview加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DebugLog(@"js finish！！！");
    //    _callbackJSFinish();
    [self setupPostMessageScript];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    self.progressView.hidden = YES;
    
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
    [webView.configuration.userContentController addUserScript:script];
    [webView evaluateJavaScript:source completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    
}
- (void)postMessage:(NSString *)message
{
    NSDictionary *eventInitDict = @{
                                    @"data": message,
                                    };
    NSString *source = [NSString
                        stringWithFormat:@"document.dispatchEvent(new MessageEvent('message', %@));",
                        [Common dictionaryToJson:eventInitDict]
                        ];
    
    
    [webView evaluateJavaScript:source completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}
/**
 webview开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DebugLog(@"js start！！！");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
}
- (void)dealloc {
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"JSCallback"];
}
/**
 webview加载失败
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DebugLog(@"js error！！！");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.progressView.hidden = YES;
}

/**
 webview拦截alert
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(
                                                                                                                                                              void))completionHandler {
    DebugLog(@"alert=%@", message);
    completionHandler();
}

/**
 webview拦截Confirm
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(
                                                                                                                                                                BOOL))completionHandler {
    DebugLog(@"confirm=%@", message);
    completionHandler(YES);
}

/**
 webview拦截Prompt
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(
                                                                                                                                                                                                    NSString *_Nullable))completionHandler {
    
    //    [self.navigationController popViewControllerAnimated:YES];
    DebugLog(@"prompt===%@", prompt);
//    [self savePrompt:prompt];
    completionHandler(@"123");
}

/**
 webview拦截js方法
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    DebugLog(@"message:%@", message);
    if ([message.name isEqualToString:@"JSCallback"]) {
        NSLog(@"message.body=%@",message.body);
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            return;
        }
        [self seveMessage:message.body];
    }
}


#pragma mark handlePrompt
// DApp 网页回调处理
- (void)seveMessage:(NSString *)prompt {
    if (![prompt containsString:@"params="]) {
        return;
    }
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    NSString *base64decodeString = [Common stringEncodeBase64:resultStr];
    NSDictionary *resultDic = [Common dictionaryWithJsonString:[base64decodeString stringByRemovingPercentEncoding]];
    self.promptDic = resultDic;
    
    InfoAlert * v = [[InfoAlert alloc]initWithTitle:self.promptDic[@"action"] msgString:[self convertToJsonData:self.promptDic] buttonString:self.promptDic[@"action"] leftString:@""];
    v.callback = ^(NSString *string) {
        if (self.promptDic[@"action"]) {
            // login
            if ([self.promptDic[@"action"] isEqualToString:@"login"]) {
                self.isLogin = YES;
                [self loginRequest:self.promptDic];
                // invoke
            }else if ([self.promptDic[@"action"] isEqualToString:@"invoke"]){
                self.isLogin = NO;
                [self invokeTransactionRequest:self.promptDic];
                // getAccount
            }else if ([self.promptDic[@"action"] isEqualToString:@"getAccount"]){
                [self getAccount:self.promptDic];
            }
        }
    };
    [v show];
}
// 登录
- (void)loginRequest:(NSDictionary*)resultDic{
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}
// 获取账户信息
-(void)getAccount:(NSDictionary*)resultDic{
    NSDictionary *params = @{@"action":@"getAccount",
                             @"version":@"v1.0.0",
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             @"result":self.defaultWalletDic[@"address"]
                             };
    NSString * jsonString = [Common dictionaryToJson:params];
    NSString *encodedURL = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *base64String = [Common base64EncodeString:encodedURL];
    NSString *jsStr = [NSString stringWithFormat:@"%@",base64String ];
    [self postMessage:jsStr];
//    [webView evaluateJavaScript:jsStr completionHandler:nil];
}
// invoke 合约
- (void)invokeTransactionRequest:(NSDictionary*)resultDic{
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}

- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            weakSelf.confirmPwd = password;
            [weakSelf loadJS];
        }];
    }
    return _sendConfirmV;
}

- (void)loadJS{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.defaultWalletDic[@"key"],[Common transferredMeaning:_confirmPwd],self.defaultWalletDic[@"address"],self.defaultWalletDic[@"salt"]];
    
    if (_confirmPwd.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}
// TS SDK 回调处理
- (void)handlePrompt:(NSString *)prompt{
    
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // 密码解密回调处理
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.confirmPwd = @"";
            [Common showToast:@"Password error"];
        }else{
            if (self.promptDic[@"action"]) {
                if ([self.promptDic[@"action"] isEqualToString:@"login"]) {
                    
                    // 对 message 签名
                    NSDictionary *params = self.promptDic[@"params"];
                    NSString *signStr =[Common hexStringFromString:params[@"message"]];
                    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.signDataHex('%@','%@','%@','%@','%@','newsignDataStrHex')",signStr,self.defaultWalletDic[@"key"],[Common base64EncodeString:_confirmPwd],self.defaultWalletDic[@"address"],self.defaultWalletDic[@"salt"]];
                    
                    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
                    __weak typeof(self) weakSelf = self;
                    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
                        [weakSelf handlePrompt:prompt];
                    }];
                    
                }else if ([self.promptDic[@"action"] isEqualToString:@"invoke"]){
                    NSString *str = [self convertToJsonData:self.promptDic];
                    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.makeDappTransaction('%@','%@','makeDappTransaction')",str,obj[@"result"]];
                    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
                    __weak typeof(self) weakSelf = self;
                    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
                        [weakSelf handlePrompt:prompt];
                    }];
                }
            }
        }
    }else if ([prompt hasPrefix:@"newsignDataStrHex"]){
        [_hub hideAnimated:YES];
        [self.sendConfirmV dismiss];
        NSDictionary *params = self.promptDic[@"params"];
        NSDictionary *result =@{@"type": @"account",
                                @"publicKey":self.defaultWalletDic[@"publicKey"],
                                @"address": self.defaultWalletDic[@"address"],
                                @"message":params[@"message"] ,
                                @"signature":obj[@"result"]
                                };
        NSDictionary *nParams = @{@"action":@"login",
                                  @"version": @"v1.0.0",
                                  @"error": @0,
                                  @"desc": @"SUCCESS",
                                  @"result":result
                                  };
        
        
        NSString *jsonString = [Common dictionaryToJson:nParams];
        NSString *encodedURL = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *base64String = [Common base64EncodeString:encodedURL];
        NSString *jsStr = [NSString stringWithFormat:@"%@",base64String ];
        [self postMessage:jsStr];
    }else if ([prompt hasPrefix:@"makeDappTransaction"]){
        self.hashString = obj[@"result"];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.checkTransaction('%@','checkTrade')",obj[@"result"]];
        
        LOADJSPRE;
        LOADJS2;
        LOADJS3;
        __weak typeof(self) weakSelf = self;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        [self.browserView setCallbackPrompt:^(NSString * prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        
    }else if ([prompt hasPrefix:@"sendTransaction"]){
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            [self.sendConfirmV dismiss];
            NSDictionary * result = obj[@"result"];
            NSDictionary *nParams = @{@"action":@"invoke",
                                      @"version": @"v1.0.0",
                                      @"error": @0,
                                      @"desc": @"SUCCESS",
                                      @"result":result[@"Result"]
                                      };
            NSString *jsonString = [Common dictionaryToJson:nParams];
            NSString *encodedURL = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *base64String = [Common base64EncodeString:encodedURL];
            NSString *jsStr = [NSString stringWithFormat:@"%@",base64String ];
            [self postMessage:jsStr];
            
        } else {
            if ([[obj valueForKey:@"error"] integerValue] > 0) {
                [Common showToast:[NSString stringWithFormat:@"%@:%@",@"System error",[obj valueForKey:@"error"]]];
                return;
            }
        }
    }else if ([prompt hasPrefix:@"checkTrade"]){
        [_hub hideAnimated:YES];
        InfoAlert * v = [[InfoAlert alloc]initWithTitle:@"result of preboot execution" msgString:[self convertToJsonData:obj] buttonString:@"Send" leftString:@"Cancel"];
        v.callback = ^(NSString *string) {
            self.hub=[ToastUtil showMessage:@"" toView:nil];
            NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",self.hashString];
            LOADJS1;
            LOADJS2;
            LOADJS3;
            __weak typeof(self) weakSelf = self;
            [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            [self.browserView setCallbackPrompt:^(NSString * prompt) {
                [weakSelf handlePrompt:prompt];
            }];
        };
        v.callleftback = ^(NSString *string) {
            
            [self.sendConfirmV dismiss];
        };
        [v show];
        
        
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//    NSString
//    *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
//    NSError *errors;
//    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

