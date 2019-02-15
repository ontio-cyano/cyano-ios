//
//  CeshiViewController.h
//  cyano
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018 LR. All rights reserved.
//

#import "BaseViewController.h"
#define ONTIDTX @"ONTIDTX"
#define DEFAULTONTID @"DEFAULTONTID"
#define DEFAULTACCOUTNKEYSTORE @"DEFAULTACCOUTNKEYSTORE"
#define DEFAULTIDENTITY @"DEFAULTIDENTITY"
#define ONTIDAUTHINFO @"ONTIDAUTHINFO"

#define ONTOLOADJSPRE  [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setServerNode('polaris5.ont.io')" completionHandler:nil]
#define ONTOLOADJS2 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]
#define ONTOLOADJS3 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil]

@interface DAppViewController : BaseViewController
@property (nonatomic,strong) NSDictionary * defaultWalletDic;
@property (nonatomic,strong) NSDictionary * dAppDic;
@property (nonatomic,copy)   NSString     * dappUrl;
@end

