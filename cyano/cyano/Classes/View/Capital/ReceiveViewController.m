//
//  ReceiveViewController.m
//  cyano
//
//  Created by Apple on 2018/12/23.
//  Copyright © 2018 LR. All rights reserved.
//

#import "ReceiveViewController.h"
#import "UITextField+LKLUITextField.h"
@interface ReceiveViewController ()
<UITextFieldDelegate>
@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createUI];
}
-(void)createUI{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    
    UIView * topV = [[UIView alloc]init];
    topV.backgroundColor = BLUELB;
    [self.view addSubview:topV];
    
    UILabel * alertLB = [[UILabel alloc]init];
    alertLB.text = @"Use your public address to send funds to your wallet.";
    alertLB.textColor = WHITE;
    alertLB.textAlignment = NSTextAlignmentCenter;
    alertLB.font = [UIFont systemFontOfSize:16];
    alertLB.numberOfLines = 0;
    [topV addSubview:alertLB];
    
    UILabel * pubkeyLB = [[UILabel alloc]init];
    pubkeyLB.text = @"Public address";
    pubkeyLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:pubkeyLB];
    
    UITextField * addressLB = [[UITextField alloc]init];
    addressLB.enabled = NO;
    addressLB.clearButtonMode = UITextFieldViewModeNever;
    addressLB.text = dict[@"address"];
    [addressLB setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    addressLB.font = [UIFont systemFontOfSize:14];
    addressLB.layer.borderWidth = 1;
    addressLB.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:addressLB];
    
    UIButton * copyBtn = [[UIButton alloc]init];
    [self.view addSubview:copyBtn];
    
    UIImageView * qrImage =[[ UIImageView alloc]init];
    qrImage.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:dict[@"address"] logoImageName:@"" logoScaleToSuperView:0.25 withWallet:NO];
    [self.view addSubview:qrImage];
    
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        
    }];
    
    [alertLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.view).offset(20*SCALE_W);
        make.bottom.equalTo(topV.mas_bottom).offset(-40*SCALE_W);
    }];
    
    [pubkeyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(topV.mas_bottom).offset(20*SCALE_W);
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(pubkeyLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(pubkeyLB.mas_bottom).offset(20*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(addressLB.mas_bottom).offset(30*SCALE_W);
        make.width.height.mas_offset(150*SCALE_W);
    }];
    
    [copyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [Common showToast:@"Copied wallet address"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = addressLB.text;
    }];
    
}
- (void)createNav{
    self.view.backgroundColor = WHITE;
    [self setNavTitle:@"Receive funds"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:@""];
}
- (void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
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
