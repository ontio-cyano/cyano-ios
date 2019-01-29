//
//  ONTOBaseViewController.h
//  cyano
//
//  Created by Apple on 2019/1/21.
//  Copyright © 2019 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ONTOBundle_Name @"cyano.bundle"
#define ONTOBundle_Path [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:ONTOBundle_Name]
#define ONTOBundle      [NSBundle bundleWithPath:ONTOBundle_Path]

#define ONTOHeight [UIScreen mainScreen].bounds.size.height
#define ONTOWidth  [UIScreen mainScreen].bounds.size.width

#define ONTOIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define ONTOIsiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ONTOIsiPhone6 (ONTOHeight == 667.0)

#define ONTIDTX @"ONTIDTX"
#define DEFAULTONTID @"DEFAULTONTID"
#define DEFAULTACCOUTNKEYSTORE @"DEFAULTACCOUTNKEYSTORE"
#define DEFAULTIDENTITY @"DEFAULTIDENTITY"
#define ONTIDAUTHINFO @"ONTIDAUTHINFO"

#define ONTOLOADJSPRE  [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setServerNode('polaris5.ont.io')" completionHandler:nil]
#define ONTOLOADJS2 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setSocketPort('20335')" completionHandler:nil]
#define ONTOLOADJS3 [self.browserView.wkWebView evaluateJavaScript:@"Ont.SDK.setRestPort('20334')" completionHandler:nil]

@interface ONTOBaseViewController : UIViewController

- (void)setNavTitle:(NSString *)title;

- (void)setNavLeftImageIcon:(UIImage *)imageIcon Title:(NSString *)title;

- (void)setNavRightImageIcon:(UIImage *)imageIcon Title:(NSString *)title;

- (void)setNavLeftItem:(UIBarButtonItem *)item;

- (void)setNavRightItem:(UIBarButtonItem *)item;

- (void)setNavLeftItems:(NSMutableArray *)array;

- (void)navLeftAction;
- (void)navRightAction;
@end

