//
//  Config.h
//  ONTO
//
//  Created by Zeus.Zhang on 2018/1/31.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#ifndef Config_h
#define Config_h

#import <YYKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
//#import "BaseNavigationViewController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "Common.h"
//#import "UIViewController+HUD.h"
//#import "UIImage+LXQRCode.h"
//#import "OTAlertView.h"
//#import "SGQRCode.h"
#import "CCRequest.h"
#import "ToastUtil.h"
#import "UIButton+Block.h"
//#import "MGPopController.h"
#import "AppHelper.h"
#import "UIImage+GradientColor.h"
//#import "UserModel.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UILabel+changeSpace.h"

#define USERMODEL   [UserModel shareInstance]
//Nav、Tab颜色字体
#define NAVBACKCOLOR [UIColor colorWithHexString:@"#FFFFFF"]
#define NAVTITLECOLOR [UIColor colorWithHexString:@"#565656"]
#define WHITE [UIColor whiteColor]
#define BUTTONBACKCOLOR [UIColor colorWithHexString:@"#e0e1e2"]
#define LBCOLOR [UIColor colorWithHexString:@"#595757"]
#define TABLEBACKCOLOR [UIColor colorWithHexString:@"#f4f4f4"] //
#define BLUELB [UIColor colorWithHexString:@"#3bb4d0"] //
#define LINEBG [UIColor colorWithHexString:@"#E9EDEF"]

#define NAVFONT [UIFont systemFontOfSize:17.0]
#define K16FONT [UIFont systemFontOfSize:16]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define HomeLanguage @"userLanguage"
#define FIRSTINITLANGUAGE @"FIRSTINITLANGUAGE"
#define UNIT @"unit"
#define kAppVersion @"appVersion"
#define ENORCN [[[NSUserDefaults standardUserDefaults] valueForKey:HomeLanguage] isEqualToString:@"en"]?@"en":@"cn"

#define ENORCNDAXIE [[[NSUserDefaults standardUserDefaults] valueForKey:HomeLanguage] isEqualToString:@"en"]?@"EN":@"CN"

//Tabbar图片
/** tab one **/
#define TABONEIMAGE [UIImage imageNamed:@"Me_ID"]
#define TABONEIMAGESELECTED [UIImage imageNamed:@"Me_ID-B"]
//#define TABONETITLE Localized(@"IDTitle")
#define TABONETITLE Localized(@"")

#define TABONECOLOR [UIColor colorWithHexString:@"#3e3e3e"]
#define TABONECOLORSELECTED [UIColor colorWithHexString:@"#2a9ad5"]
/** tab two **/
#define TABTWOIMAGE [UIImage imageNamed:@"Me_A"]
#define TABTWOIMAGESELECTED [UIImage imageNamed:@"Me_A-b"]
//#define TABTWOTITLE Localized(@"AssetTitle")
#define TABTWOTITLE Localized(@"")

#define TABTWOCOLOR [UIColor colorWithHexString:@"#3e3e3e"]
#define TABTWOCOLORSELECTED [UIColor colorWithHexString:@"#2a9ad5"]

/** tab three **/
#define TABTHREEIMAGE [UIImage imageNamed:@"more_unselected"]
#define TABTHREEIMAGENOTIFICAION [UIImage imageNamed:@"Me_More_h"]

#define TABTHREEIMAGESELECTED [UIImage imageNamed:@"more_selected"]
//#define TABTHREETITLE Localized(@"More")
#define TABTHREETITLE Localized(@"")

#define TABTHREECOLOR [UIColor colorWithHexString:@"#3e3e3e"]
#define TABTHREECOLORSELECTED [UIColor colorWithHexString:@"#2a9ad5"]

#define TABFOURIMAGE [UIImage imageNamed:@"tab_me"]
#define TABFOURIMAGESELECTED [UIImage imageNamed:@"tab_me_selected"]
#define APPWINDOW [[[UIApplication sharedApplication]windows] objectAtIndex:0]

//国际化
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"] 

//节点
#define SERVERNODE  [NSString stringWithFormat:@"Ont.SDK.setServerNode('%@')",[[NSUserDefaults standardUserDefaults]valueForKey:TESTNETADDR]]

//iPhone X
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// iphone5/se
#define KIsiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// UIScreen width.

#define  LL_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  LL_ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  LL_iPhoneX (LL_ScreenWidth == 375.f && LL_ScreenHeight == 812.f ? YES : NO)
#define  LL_StatusBarHeight      (LL_iPhoneX ? 44.f : 20.f)
#define  LL_NavigationBarHeight  44.f

#define  LL_TabbarHeight         (LL_iPhoneX ? (49.f+34.f) : 49.f)
#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)
#define  LL_StatusBarAndNavigationBarHeight  (LL_iPhoneX ? 88.f : 64.f)
#define  LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define  LL_iPhone5S (LL_ScreenWidth == 320.f? YES : NO)







#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//节点方法
//#define LOADJS1 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setServerNode('polaris1.ont.io')" completionHandler:nil]
#define LOADJS1 [self.browserView.wkWebView evaluateJavaScript:SERVERNODE completionHandler:nil]

#define LOADJS2 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]
#define LOADJS3 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil]

#define LOADJS [self.browserView.wkWebView evaluateJavaScript:SERVERNODE completionHandler:nil]; \
[self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]; \
[self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil];

#define APP_ACCOUNT @"DEFAULTACCOUTN"
#define ASSET_ACCOUNT @"ASSETACCOUNT"
#define ALLASSET_ACCOUNT @"ALLASSETACCOUNT"
#define ALLCONTACT_LIST @"ALLCONTACT_LIST"
#define ALLSWAP @"ALLSWAP"


#define IDENTITY_CREATED @"IDENTITY_CREATED"
#define IDENTITY_BACKUPED @"IDENTITY_BACKUPED"
#define IDENTITY_EXISIT @"IDENTITY_EXISIT"

#define ONT_ID @"ONT_ID"
#define DEVICE_CODE @"DEVICE_CODE"
#define ENCRYPTED_PRIVATEKEY @"ENCRYPTED_PRIVATEKEY"
#define ISFIRST_BACKUP @"ISFIRST_BACKUP"
#define IDENTITY_NAME @"IDENTITYNAME"
#define NOTICETIONTIME @"NOTICETIONTIME"
#define ISTOUCHIDON @"ISTOUCHIDON"




#define START @"START"
#define SELECTINDEX @"selectIndex"
#define NOTIFICATIONSELECTINDEX @"NOTIFICATIONSELECTINDEX"
#define SELECTWALLET @"SELECTWALLET"
#define ISBACKUPONTID @"ISBACKUPONTID"


#define WALLETSELECTINDEX @"WALLETSELECTINDEX"
#define NOTIFICATION_SOCKET_GETCLAIM @"NOTIFICATION_SOCKET_GETCLAIM"
#define NOTIFICATION_SOCKET_LOGOUT @"NOTIFICATION_SOCKET_LOGOUT"
#define NOTIFICATION_SOCKET_APPACTIVE @"NOTIFICATION_SOCKET_APPACTIVE"
#define ISNOTIFICATION @"ISNOTIFICATION"
#define GETNETNOTIFICATION @"GETNETNOTIFICATION"  //有网络通知
#define NONNETNOTIFICATION @"NONNETNOTIFICATION"  //无网络通知
#define EXPIRENOTIFICATION @"EXPIRENOTIFICATION"  //过期重新登录
#define EXPIREMANAGENOTIFICATION @"EXPIREMANAGENOTIFICATION"  //切换身份过期重新登录
#define RESPONSIBLENOTIFICATION @"RESPONSIBLENOTIFICATION"  //免责声明通知
#define CHECKTRANSFER @"CHECKTRANSFER"  //检查交易成功通知
#define NEEDLOGIN_NOTIFICATION @"NEEDLOGIN_NOTIFICATION"  //需要指纹登录通知

#define MYCHECKTRANSFER @"MYCHECKTRANSFER"  //检查交易成功通知

#define CHECKTRANSFERTOMORE @"CHECKTRANSFERTOMORE"  //给more页面发送检查交易成功通知
#define APPTERMS @"https://onto.app/terms"  //用户条款链接
#define APPPRIVACY @"https://onto.app/privacy"  //隐私策略链接


#define FEE @"FEE"
#define LOGOUTTIME @"LOGOUTTIME"
#define TESTNETADDR @"TESTNETADDR"
#define ONTPASSADDRSS @"ONTPASSADDRSS"
#define NETNAME @"NETNAME"

#define ONTIDGASPRICE @"ONTIDGASPRICE"
#define ONTIDGASLIMIT @"ONTIDGASLIMIT"
#define ASSETGASPRICE @"ASSETGASPRICE"
#define ASSETGASLIMIT @"ASSETGASLIMIT"
#define GASPRICEMAX @"GASPRICEMAX"
#define ISONGSELFPAY @"ISONGSELFPAY"

#define MINCLAIMABLEONG @"MINCLAIMABLEONG"
#define MINUNBOUNDONG @"MINUNBOUNDONG"




#define IDAUTHARR @"IDAUTHARR"
#define SOCIALAUCHARR @"SOCIALAUCHARR"
#define APPAUCHARR @"APPAUCHARR"
#define APPMAUCHARR @"APPMAUCHARR"

#define SYSTEMNOTIFICATIONLIST @"SYSTEMNOTIFICATIONLIST"
#define LAQUSYSTEMNOTIFICATIONLIST @"LAQUSYSTEMNOTIFICATIONLIST"

#define ONTNEP5 @"ONT (NEP-5)"


//屏幕宽高
#define SYSHeight [UIScreen mainScreen].bounds.size.height
#define SYSWidth  [UIScreen mainScreen].bounds.size.width
#define SCALE_W  ([[UIScreen mainScreen] bounds].size.width/375)
#define SafeAreaTopHeight (kScreenHeight == 812.0 ? 88 : 64)
#define StatusBarHeight (kScreenHeight == 812.0 ? 44 : 20)
#define MainColor [UIColor colorWithHexString:@"#32A4BE"]
#define TUSIHeight (kScreenHeight == 812.0 ? 169 : 135)
#define SafeBottomHeight (kScreenHeight == 812.0 ? 34 : 0)
#define PhotoBottomHeight  (kScreenHeight == 812.0 ? 83 : 0)
#define PhotoTopHeight  (kScreenHeight == 812.0 ? 64 : 0)
//x的判断
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define ONG_PRECISION_STR @"1000000000"
#define NEP5_PRECISION_STR @"100000000"
#define ONG_ZERO @"0.000000000"
#endif /* Config_h */

