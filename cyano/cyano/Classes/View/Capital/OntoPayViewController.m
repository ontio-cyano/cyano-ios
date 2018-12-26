//
//  OntoPayLoginViewController.m
//  cyano
//
//  Created by Apple on 2018/12/24.
//  Copyright © 2018 LR. All rights reserved.
//

#import "OntoPayLoginViewController.h"
#import "SendConfirmView.h"
@interface OntoPayLoginViewController ()
@property(nonatomic,strong)NSDictionary *defaultDic;
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,copy)NSString *passwordString;
@property(nonatomic,strong)MBProgressHUD *hub;
@end

@implementation OntoPayLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultDic = _walletArr[0];
    [self configUI];
    [self configNav];
}
-(void)configUI{
    self.view.backgroundColor = WHITE;
    UIImageView * imageV =[[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"RegisterONTOLogo"];
    [self.view addSubview:imageV];
    
    UILabel * thirdName = [[UILabel alloc]init];
    thirdName.text = @"Ontology dApp Log-In Request";
    thirdName.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [thirdName changeSpace:0 wordSpace:1*SCALE_W];
    thirdName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdName];
    
    UILabel * requiredLB = [[UILabel alloc]init];
    requiredLB.text = @"Requirements:";
    requiredLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [requiredLB changeSpace:0 wordSpace:1];
    requiredLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:requiredLB];
    
    UIImageView * dotImage1 =[[UIImageView alloc]init];
    dotImage1.layer.cornerRadius = 3.5*SCALE_W;
    dotImage1.backgroundColor = [UIColor colorWithHexString:@"#6E6F70"];
    [self.view addSubview:dotImage1];
    
    UIImageView * dotImage2 =[[UIImageView alloc]init];
    dotImage2.layer.cornerRadius = 3.5*SCALE_W;
    dotImage2.backgroundColor = [UIColor colorWithHexString:@"#6E6F70"];
    [self.view addSubview:dotImage2];
    
    UILabel * requiredLB1 =[[UILabel alloc]init];
    requiredLB1.numberOfLines = 0;
    requiredLB1.text = @"Verify your identity";
    requiredLB1.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [requiredLB1 changeSpace:0 wordSpace:1];
    requiredLB1.textAlignment = NSTextAlignmentLeft;
    requiredLB1.numberOfLines = 0;
    [self.view addSubview:requiredLB1];
    
    UILabel * requiredLB2 =[[UILabel alloc]init];
    requiredLB2.numberOfLines = 0;
    requiredLB2.text = @"choose your log-in wallet";
    requiredLB2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [requiredLB2 changeSpace:0 wordSpace:1];
    requiredLB2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:requiredLB2];
    
    UILabel * FromLB =[[UILabel alloc]init];
    FromLB.text = @"Payment wallet";
    FromLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [FromLB changeSpace:0 wordSpace:1];
    FromLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:FromLB];
    
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [btn.titleLabel changeSpace:0 wordSpace:3*SCALE_W];
    [self.view addSubview:btn];
    
    UILabel * nameLB =[[UILabel alloc]init];
    nameLB.text = self.defaultDic[@"label"];
    nameLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    //    [nameLB changeSpace:0 wordSpace:1];
    nameLB.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    nameLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameLB];
    
    UILabel * addressLB =[[UILabel alloc]init];
    addressLB.text = self.defaultDic[@"address"];
    addressLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    //    [nameLB changeSpace:0 wordSpace:1];
    addressLB.textColor = [UIColor colorWithHexString:@"#000000"];
    addressLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:addressLB];
    
    UIView * line =[[ UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:line];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(15*SCALE_W);
        make.width.height.mas_offset(60*SCALE_W);
    }];
    
    [thirdName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(15*SCALE_W);
        make.centerX.equalTo(self.view);
    }];
    
    [requiredLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(thirdName.mas_bottom).offset(30*SCALE_W);
    }];
    
    [dotImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.width.height.mas_offset(7*SCALE_W);
        make.top.equalTo(requiredLB.mas_bottom).offset(19*SCALE_W);
    }];
    
    
    
    [requiredLB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(requiredLB.mas_bottom).offset(15*SCALE_W);
    }];
    
    [dotImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.width.height.mas_offset(7*SCALE_W);
        make.top.equalTo(requiredLB1.mas_bottom).offset(10*SCALE_W);
    }];
    [requiredLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35*SCALE_W);
        make.right.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(requiredLB1.mas_bottom).offset(5*SCALE_W);
    }];
    
    [FromLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(requiredLB2.mas_bottom).offset(18*SCALE_W);
    }];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(FromLB.mas_bottom).offset(12*SCALE_W);
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FromLB);
        make.top.equalTo(nameLB.mas_bottom).offset(6*SCALE_W);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.height.mas_offset(1);
        make.top.equalTo(addressLB.mas_bottom).offset(18*SCALE_W);
    }];
    
   
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-40*SCALE_W - 34);
        }else{
            make.bottom.equalTo(self.view).offset(-40*SCALE_W );
        }
    }];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
    }];
}

- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            weakSelf.passwordString = password;
            [weakSelf loadJS];
        }];
    }
    return _sendConfirmV;
}

- (void)loadJS{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.defaultDic[@"key"],[Common transferredMeaning:_passwordString],self.defaultDic[@"address"],self.defaultDic[@"salt"]];
    
    if (_passwordString.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}

// TS SDK 回调处理
- (void)handlePrompt:(NSString *)prompt{
    
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // 密码解密回调处理
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.passwordString = @"";
            [Common showToast:@"Password error"];
        }else{
            [self loginThird];
        }
    }else if ([prompt hasPrefix:@"newsignDataStr"]) {
        NSLog(@"%@",prompt);
        [self togiveLoginInfo:obj[@"result"]];
    }
    
}
-(void)loginThird{
    NSDictionary * dic = _payInfo[@"params"];
    NSString * signStr = [Common hexStringFromString:dic[@"message"]];
    NSString * jsStr = [NSString stringWithFormat:@"Ont.SDK.signDataHex('%@','%@','%@','%@','%@','newsignDataStr')",signStr,_defaultDic[@"key"],[Common base64EncodeString:_passwordString],_defaultDic[@"address"],_defaultDic[@"salt"]];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
-(void)togiveLoginInfo:(NSString*)infoString{
    NSDictionary * dic = _payInfo[@"params"];
    NSDictionary * params = @{@"user":self.defaultDic[@"address"],
                              @"message":dic[@"message"],
                              @"publickey":self.defaultDic[@"publicKey"],
                              @"signature":infoString,
                              @"type":@"account"
                              };
    NSDictionary * submitDic = @{@"action":@"login",@"version":@"v1.0.0",@"params":params};
    [[CCRequest shareInstance]requestWithURLString:dic[@"callback"] MethodType:MethodTypePOST Params:submitDic Success:^(id responseObject, id responseOriginal) {
        if (self.hub != nil) {
            [self.hub hideAnimated:YES];
        }
        [self.sendConfirmV dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        if (self.hub != nil) {
            [self.hub hideAnimated:YES];
        }
        [self.sendConfirmV dismiss];
    }];
}
// 导航栏设置
- (void)configNav {
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:Localized(@"Back")];
    
}

// 返回
- (void)navLeftAction {
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
