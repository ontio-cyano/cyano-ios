//
//  DiscoverViewController.m
//  Cyano Wallet
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DAppViewController.h"
@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    [self setNavTitle:@"发现"];
    UIButton * discoverButton = [[UIButton alloc]init];
    [discoverButton setTitle:@"DISCOVER" forState:UIControlStateNormal];
    [discoverButton setTitleColor:BLUELB forState:UIControlStateNormal];
    discoverButton.backgroundColor = BUTTONBACKCOLOR;
    discoverButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:discoverButton];
    
    [discoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_offset(200*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
    }];
    
    [discoverButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
        NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
        DAppViewController * vc = [[DAppViewController alloc]init];
        vc.defaultWalletDic = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }];
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
