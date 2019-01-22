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
#define ONTOIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
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

