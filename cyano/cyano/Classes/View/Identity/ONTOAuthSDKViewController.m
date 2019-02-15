//
//  ONTOAuthSDKViewController.m
//  cyano
//
//  Created by Apple on 2019/1/25.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTOAuthSDKViewController.h"
#import "ONTIdExportViewController.h"
#import "ONTIdWebView.h"
#import "PasswordSheet.h"
@interface ONTOAuthSDKViewController ()
@property (strong, nonatomic) ONTIdWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property(nonatomic,strong)UIWindow         *window;
@end

@implementation ONTOAuthSDKViewController

- (void)dealloc
{
    NSLog(@"ONTOSDKViewController dealloc...");
    [self.webView.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutMainView];
    
    [self createNav];
    
    [self initHandler];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)layoutMainView
{
    // Web View
    self.webView = [[ONTIdWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    NSString * urlStr = [NSString stringWithFormat:@"https://auth.ont.io/#/mgmtHome?ontid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTONTID]];
    [self.webView setURL:urlStr];
    // Progress
    [self layoutProgressView];
}

- (void)initHandler{
    __weak typeof(self) weakSelf = self;
    
    
    [self.webView setAuthenticationCallback:^(NSDictionary * callbackDic) {
        NSDictionary * params = callbackDic[@"params"];
        NSString * subaction = params[@"subaction"];
        NSArray * allSubaction = @[@"getRegistryOntidTx",@"submit",@"getIdentity"];
        NSInteger index = [allSubaction indexOfObject:subaction];
        switch (index) {
                case 0:
                [weakSelf getRegistryOntidTxRequest:callbackDic];
                break;
                case 1:
                [weakSelf submitRequest:callbackDic];
                break;
                case 2:
                [weakSelf getIdentityRequest:callbackDic];
                break;
            default:
                break;
        }
    }];
    
    [self.webView setAuthorizationCallback:^(NSDictionary *callbackDic) {
        NSDictionary * params = callbackDic[@"params"];
        NSString * subaction = params[@"subaction"];
        NSArray * allSubaction = @[@"exportOntid",@"deleteOntid",@"decryptClaim",@"getAuthorizationInfo",@"requestAuthorization"];
        NSInteger index = [allSubaction indexOfObject:subaction];
        switch (index) {
                case 0:
                [weakSelf exportOntidRequest:callbackDic];
                break;
                case 1:
                [weakSelf deleteOntidRequest:callbackDic];
                break;
                case 2:
                [weakSelf decryptClaimRequest:callbackDic];
                break;
                case 3:
                [weakSelf getAuthorizationInfoRequest:callbackDic];
                break;
                case 4:
                [weakSelf requestAuthorizationRequest:callbackDic];
                break;
            default:
                break;
        }
    }];
     
     [self.webView setGetIdentityCallback:^(NSDictionary *callbackDic) {
         [weakSelf getIdentityRequest:callbackDic];
        
     }];
}

-(void)getRegistryOntidTxRequest:(NSDictionary*)callbackDic{
    NSString * registryOntidTx;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:ONTIDTX]) {
        registryOntidTx = [[NSUserDefaults standardUserDefaults] valueForKey:ONTIDTX];
    }else{
        registryOntidTx = @"";
    }
    NSDictionary *params = @{
                             @"action":@"authentication",
                             @"version":callbackDic[@"version"],
                             @"result":
                                 @{
                                     @"subaction":@"getRegistryOntidTx",
                                     @"ontid":[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTONTID],
                                     @"registryOntidTx":registryOntidTx
                                     },
                             @"id":callbackDic[@"id"],
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             };
    [self.webView sendMessageToWeb:params];
}

-(void)submitRequest:(NSDictionary*)callbackDic{
    NSDictionary *params = @{
                             @"action":@"authentication",
                             @"version":callbackDic[@"version"],
                             @"result":@1,
                             @"id":callbackDic[@"id"],
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             };
    [self.webView sendMessageToWeb:params];
}
-(void)exportOntidRequest:(NSDictionary*)callbackDic{
    NSDictionary * dic  = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTIDENTITY];
    PasswordSheet* sheetV= [[PasswordSheet alloc]initWithTitle:@"Enter Your ONT ID Password" selectedDic:dic action:@"exportOntid" message:nil];
    sheetV.callback = ^(NSString *WIFString ) {
        ONTIdExportViewController * vc = [[ONTIdExportViewController alloc]init];
        vc.WIFString = WIFString;
        [self.navigationController pushViewController:vc animated:YES];
    };
    sheetV.errorCallback = ^(NSDictionary *errorInfo) {
        NSDictionary *errorParams = @{@"action":callbackDic[@"action"],
                                  @"error": errorInfo[@"error"],
                                  @"desc": @"ERROR",
                                  @"result":errorInfo[@"result"],
                                  @"id":callbackDic[@"id"],
                                  @"version":callbackDic[@"version"]
                                  };
        [self.webView sendMessageToWeb:errorParams];
    };
    
    _window = [[[UIApplication sharedApplication]windows] objectAtIndex:1];
    [_window addSubview:sheetV];
    [_window makeKeyAndVisible];
}
-(void)deleteOntidRequest:(NSDictionary*)callbackDic{
    NSDictionary * dic  = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTIDENTITY];
    PasswordSheet* sheetV= [[PasswordSheet alloc]initWithTitle:@"Enter Your ONT ID Password" selectedDic:dic action:@"deleteOntid" message:nil];
    sheetV.callback = ^(NSString *str ) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULTONTID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ONTIDTX];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULTACCOUTNKEYSTORE];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEFAULTIDENTITY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    sheetV.errorCallback = ^(NSDictionary *errorInfo) {
        NSDictionary *errorParams = @{@"action":callbackDic[@"action"],
                                      @"error": errorInfo[@"error"],
                                      @"desc": @"ERROR",
                                      @"result":errorInfo[@"result"],
                                      @"id":callbackDic[@"id"],
                                      @"version":callbackDic[@"version"]
                                      };
        [self.webView sendMessageToWeb:errorParams];
    };
    _window = [[[UIApplication sharedApplication]windows] objectAtIndex:1];
    [_window addSubview:sheetV];
    [_window makeKeyAndVisible];
}

-(void)decryptClaimRequest:(NSDictionary*)callbackDic{
    NSDictionary * dic  = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTIDENTITY];
    NSDictionary * params = callbackDic[@"params"];
    NSArray * message = params[@"message"];
    PasswordSheet* sheetV= [[PasswordSheet alloc]initWithTitle:@"Enter Your ONT ID Password" selectedDic:dic action:@"decryptClaim" message:message];
    sheetV.callback = ^(NSString *str ) {
        NSDictionary *params = @{
                                 @"action":@"authorization",
                                 @"version":callbackDic[@"version"],
                                 @"result":str,
                                 @"id":callbackDic[@"id"],
                                 @"error":@0,
                                 @"desc":@"SUCCESS",
                                 };
        [self.webView sendMessageToWeb:params];
    };
    sheetV.errorCallback = ^(NSDictionary *errorInfo) {
        NSDictionary *errorParams = @{@"action":callbackDic[@"action"],
                                      @"error": errorInfo[@"error"],
                                      @"desc": @"ERROR",
                                      @"result":errorInfo[@"result"],
                                      @"id":callbackDic[@"id"],
                                      @"version":callbackDic[@"version"]
                                      };
        [self.webView sendMessageToWeb:errorParams];
    };
    _window = [[[UIApplication sharedApplication]windows] objectAtIndex:1];
    [_window addSubview:sheetV];
    [_window makeKeyAndVisible];
}

-(void)getIdentityRequest:(NSDictionary*)callbackDic{
    NSDictionary *params = @{
                             @"action":@"authentication",
                             @"version":callbackDic[@"version"],
                             @"result":[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTONTID],
                             @"id":callbackDic[@"id"],
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             };
    [self.webView sendMessageToWeb:params];
}
-(void)getAuthorizationInfoRequest:(NSDictionary*)callbackDic{
    NSDictionary * resultDic = [[NSUserDefaults standardUserDefaults] valueForKey:ONTIDAUTHINFO];
    NSDictionary * resultParams = resultDic[@"params"];
    NSMutableDictionary * resultParamsChange = [NSMutableDictionary dictionaryWithDictionary:resultParams];
    resultParamsChange[@"subaction"] = @"getAuthorizationInfo";
    NSDictionary *params = @{
                             @"action":@"authorization",
                             @"version":callbackDic[@"version"],
                             @"result":resultParamsChange,
                             @"id":callbackDic[@"id"],
                             @"error":@0,
                             @"desc":@"SUCCESS",
                             };
    [self.webView sendMessageToWeb:params];
}

-(void)requestAuthorizationRequest:(NSDictionary*)callbackDic{
    [[NSUserDefaults standardUserDefaults]setObject:callbackDic forKey:ONTIDAUTHINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
    self.webView = [[ONTIdWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    NSString * urlStr = @"https://auth.ont.io/#/authHome";
    [self.webView setURL:urlStr];
    
    // Progress
    [self layoutProgressView];
    [self initHandler];
}

#pragma mark - Progress

- (void)layoutProgressView
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1.0f)];
    self.progressView.tintColor = [UIColor colorWithHexString:@"#32A4BE"];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.webView.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1)
        {
            [UIView animateWithDuration:0.2f animations:^ {
                self.progressView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.progressView removeFromSuperview];
            }];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)createNav{
    [self setNavLeftImageIcon:[UIImage imageNamed:@"ONTOBack" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
    [self setNavTitle:@"ONT ID"];
}
-(void)navLeftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
