//
//  MainViewController.m
//  YONGMIN2.0
//
//  Created by Apple on 16/6/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "CapitalViewController.h"
#import "MineViewController.h"
#import "IdentityViewController.h"
#import "CusNavigationController.h"
@interface MainViewController ()
{
    CapitalViewController *vc1;
    IdentityViewController*vc2;
    DiscoverViewController *vc3;
    MineViewController *vc4;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createTabBarItem];
}

-(void)createViewControllers{
    if (vc1==nil) {
        vc1 = [[CapitalViewController alloc]init];
    }
    CusNavigationController*nc1=[[CusNavigationController alloc]initWithRootViewController:vc1];
    
    if (vc2==nil) {
        vc2=[[IdentityViewController alloc]init];
    }
    CusNavigationController*nc2=[[CusNavigationController alloc]initWithRootViewController:vc2];
    
    if (vc3==nil) {
        vc3=[[DiscoverViewController alloc]init];
    }
    CusNavigationController*nc3=[[CusNavigationController alloc]initWithRootViewController:vc3];
    if (vc4==nil) {
        vc4=[[MineViewController alloc]init];
    }
    CusNavigationController*nc4=[[CusNavigationController alloc]initWithRootViewController:vc4];
    self.viewControllers=@[nc1,nc2,nc3,nc4];
}

-(void)createTabBarItem{
    NSArray*selectImage=@[@"Me_A-b",@"Me_ID-B",@"findBlack",@"more_selected"];
    NSArray*UnselectImage=@[@"Me_A",@"Me_ID",@"find",@"more_unselected"];
    NSArray*UnselectImageTitle=@[@"Asset",@"Ont id",@"DApp",@"Setting"];
    for (int i=0; i<self.tabBar.items.count;i++) {
        self.tabBar.hidden = NO;
        UITabBarItem*item=self.tabBar.items[i];
        UIImage*image=[UIImage imageNamed:UnselectImage[i]];
        //使用原来的图片样子，否则会只有蓝色阴影的图片
        image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage*selectImage1=[UIImage imageNamed:selectImage[i]];
        selectImage1=[selectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem*item1=  [item initWithTitle:nil image:image selectedImage:selectImage1];
        item1.title=UnselectImageTitle[i];
        
    }
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5f5f5f"]} forState:UIControlStateSelected];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b1b2b3"]} forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
