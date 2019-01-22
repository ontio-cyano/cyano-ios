//
//  ONTOBaseViewController.m
//  cyano
//
//  Created by Apple on 2019/1/21.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTOBaseViewController.h"


@interface ONTOBaseViewController ()

@end

@implementation ONTOBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)setNavTitle:(NSString *)title {
    self.navigationItem.title = title;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3bb4d0"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)setNavLeftImageIcon:(UIImage *)imageIcon Title:(NSString *)title{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 0, 70, 44);
    [button setTitleColor:[UIColor colorWithHexString:@"#565656"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
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
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
