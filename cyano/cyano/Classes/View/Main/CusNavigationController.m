//
//  CusNavigationController.m
//  YONGMIN2.0
//
//  Created by 梁先华 on 16/10/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CusNavigationController.h"

@interface CusNavigationController ()

@end

@implementation CusNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed =YES;
        
    }
    [super pushViewController:viewController animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////支持旋转
//-(BOOL)shouldAutorotate{
//    return [self.topViewController shouldAutorotate];
//}
//
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.topViewController supportedInterfaceOrientations];
//}
@end
