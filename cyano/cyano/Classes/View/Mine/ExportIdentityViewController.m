//
//  ExportIdentityViewController.m
//  cyano
//
//  Created by Apple on 2019/1/8.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ExportIdentityViewController.h"



@interface ExportIdentityViewController ()

@end

@implementation ExportIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}
-(void)configUI{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:APP_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No Wallet"];
        return;
    }
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    NSDictionary *controlsDic = dict[@"controls"][0];
    NSLog(@"idDic=%@",dict);
    UILabel * addressLB = [[UILabel alloc]init];
    addressLB.text = @"Address:";
    addressLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:addressLB];
    
    UILabel * addressDetailLB = [[UILabel alloc]init];
    addressDetailLB.text = controlsDic[@"address"];
    addressDetailLB.font = [UIFont systemFontOfSize:14];
    addressDetailLB.numberOfLines = 0;
    addressDetailLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:addressDetailLB];
    
    UIButton * copyAdd = [[UIButton alloc]init];
    [self.view addSubview:copyAdd];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UILabel * privatekeyLB = [[UILabel alloc]init];
    privatekeyLB.text = @"Private key:";
    privatekeyLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:privatekeyLB];
    
    UILabel * privatekeyDetailLB = [[UILabel alloc]init];
    privatekeyDetailLB.text = _keyString;
    privatekeyDetailLB.font = [UIFont systemFontOfSize:14];
    privatekeyDetailLB.numberOfLines = 0;
    privatekeyDetailLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:privatekeyDetailLB];
    
    UIButton * copykey = [[UIButton alloc]init];
    [self.view addSubview:copykey];
    
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    UILabel * WIFLB = [[UILabel alloc]init];
    WIFLB.text = @"WIF:";
    WIFLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:WIFLB];
    
    UILabel * WIFDetailLB = [[UILabel alloc]init];
    WIFDetailLB.text = _wifString;
    WIFDetailLB.font = [UIFont systemFontOfSize:14];
    WIFDetailLB.numberOfLines = 0;
    WIFDetailLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:WIFDetailLB];
    
    UIButton * copyWIF = [[UIButton alloc]init];
    [self.view addSubview:copyWIF];
    
    UIView * line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    
    [copyAdd handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"111");
        [Common showToast:@"Copied identity address"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = addressDetailLB.text;
    }];
    
    [copykey handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"222");
        [Common showToast:@"Copied private key"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = privatekeyDetailLB.text;
    }];
    
    [copyWIF handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"333");
        [Common showToast:@"Copied WIF"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = WIFDetailLB.text;
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(self.view).offset(30*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
    }];
    
    [addressDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addressLB);
        make.top.equalTo(addressLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [copyAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(addressDetailLB);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addressDetailLB);
        make.height.mas_offset(1);
        make.top.equalTo(addressDetailLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [privatekeyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(line.mas_bottom).offset(20*SCALE_W);
    }];
    
    [privatekeyDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(privatekeyLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [copykey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(privatekeyDetailLB);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addressDetailLB);
        make.height.mas_offset(1);
        make.top.equalTo(privatekeyDetailLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [WIFLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(line1.mas_bottom).offset(20*SCALE_W);
    }];
    
    [WIFDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(WIFLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [copyWIF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(WIFDetailLB);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addressDetailLB);
        make.height.mas_offset(1);
        make.top.equalTo(WIFDetailLB.mas_bottom).offset(10*SCALE_W);
    }];
    
}
// 导航栏设置
- (void)configNav {
    self.view.backgroundColor = WHITE;
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:Localized(@"Back")];
    
}

// 返回
- (void)navLeftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
