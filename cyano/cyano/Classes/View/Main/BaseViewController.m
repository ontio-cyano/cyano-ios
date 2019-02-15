//
//  BaseViewController.m
//  link2svc_2d_mobile_ios
//
//  Created by Zeus.Zhang on 2017/10/11.
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
 */

#import "BaseViewController.h"
#define KEYBOARD_NIB_PATH @"BangcleSafeKeyBoard.bundle/resources/HYKeyboard"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = BLUELB;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:BLUELB] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]]; //去除导航条下的阴影线条
    [self setNavTitleAttributesWithColor:NAVTITLECOLOR Font:K16FONT];
//    [self setupForDismissKeyboard];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presenLogin) name:NEEDLOGIN_NOTIFICATION object:nil];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决安全域问题
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getClaimNotice) name:NOTIFICATION_SOCKET_GETCLAIM object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNetWork) name:GETNETNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nonNetWork) name:NONNETNOTIFICATION object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:BLUELB] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                                                          [UIColor colorWithHexString:@"#ffffff"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]}];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getNetWork{
    _isNetWorkConnect = YES;
}

- (void)nonNetWork{
    _isNetWorkConnect = NO;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (BOOL)shouldBegin {
    return  YES;
}

- (void)setNavTitle:(NSString *)title {
    self.navigationItem.title = title;
    
    
}

- (void)setNavTitleAttributesWithColor:(UIColor *)textColor Font:(UIFont *)textFont {
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textColor,NSForegroundColorAttributeName,textFont,NSFontAttributeName, nil]];
}

-(void)setNavLeftImageIcon:(UIImage *)imageIcon Title:(NSString *)title{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 0, 70, 44);
//    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:NAVTITLECOLOR forState:UIControlStateNormal];
    button.titleLabel.font = NAVFONT;
    button.titleLabel.numberOfLines = 0;
    [button setImage:imageIcon forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, button.frame.size.width - imageIcon.size.width - 20)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

-(void)setNavRightImageIcon:(UIImage *)imageIcon Title:(NSString *)title{
    UIButton *_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#6A797C"] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = NAVFONT;
    _rightButton.titleLabel.numberOfLines = 0;
    [_rightButton setImage:imageIcon forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, _rightButton.titleLabel.width, 0, -_rightButton.titleLabel.width)];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
}

-(void)setNavLeftItem:(UIBarButtonItem *)item{
    self.navigationItem.leftBarButtonItem = item;
}

-(void)setNavRightItem:(UIBarButtonItem *)item{
    self.navigationItem.rightBarButtonItem = item;
}

-(void)setNavLeftItems:(NSMutableArray *)array{
    self.navigationItem.leftBarButtonItems = array;
}

-(void)setNavRightItems:(NSMutableArray *)array{
    self.navigationItem.rightBarButtonItems = array;
}

#pragma mark -BaseActions
-(void)navLeftAction {
    
}

-(void)navRightAction {
    
}
//
//+ (BOOL)setTabbarItemWithItemTitle:(NSString *)itemTitle
//                    ItemTitleColor:(UIColor *)itemTitleColor
//            ItemTitleColorSelected:(UIColor *)itemTitleColorSelected
//                     ItemTitleFont:(UIFont *)itemTitleFont
//                         ItemImage:(UIImage *)itemImage
//                 ItemImageSelected:(UIImage *)itemImageSelected
//                           AtIndex:(int)index
//                      SourceTabbar:(UITabBarController *)sourceTabbar {
//    if ([sourceTabbar.tabBar.items count] <= index) {
//        return NO;
//    }
//    
//    [sourceTabbar.tabBar setShadowImage:[UIImage imageWithColor:[UIColor redColor]]]; //tabbar背景图片
//     CGFloat offset = 5.0;
//    UITabBarItem *itemModify = [sourceTabbar.tabBar.items objectAtIndex:index];
//    itemModify.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//    itemModify.titlePositionAdjustment = UIOffsetMake(0, 10);
//    CGRect rect = CGRectMake(0, 0, kScreenWidth, 0.5);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,[UIColor colorWithHexString:@"#E9EDEF"].CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    DebugLog(@"img=%f",img.size.height);
//    [sourceTabbar.tabBar setShadowImage:img];
//    [sourceTabbar.tabBar setBackgroundColor:[UIColor whiteColor]];
//    [sourceTabbar.tabBar setBackgroundImage:[[UIImage alloc]init]];
//    
////    [itemModify setTitle:itemTitle];
//    [itemModify setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:itemTitleColor,NSForegroundColorAttributeName,itemTitleFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [itemModify setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:itemTitleColorSelected,NSForegroundColorAttributeName,itemTitleFont,NSFontAttributeName, nil] forState:UIControlStateSelected];
//    [itemModify setImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [itemModify setSelectedImage:[itemImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    return YES;
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
