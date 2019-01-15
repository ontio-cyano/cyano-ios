//
//  OntoPaySendViewController.m
//  cyano
//
//  Created by Apple on 2018/12/24.
//  Copyright © 2018 LR. All rights reserved.
//

#import "OntoPaySendViewController.h"
#import "SendConfirmView.h"
@interface OntoPaySendViewController ()
@property(nonatomic, strong) SendConfirmView *sendConfirmV;
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, strong) MBProgressHUD *hub;
@end

@implementation OntoPaySendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}
- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
        }];
    }
    return _browserView;
}

- (void)handlePrompt:(NSString *)prompt{
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"sendTransaction"]) {
        [_hub hideAnimated:YES];
        if (!obj[@"error"]) {
            return;
        }
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            if (_callback) {
                [self sendHash:NO];
            }
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [Common showToast:@"The transaction has been issued."];
            if (_callback) {
                [self sendHash:YES];
            }
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)sendHash:(BOOL)isSuccess{
    NSDictionary * params;
    NSString * idStr = @"";
    if (self.payDetailDic[@"id"]) {
        idStr = self.payDetailDic[@"id"];
    }
    NSString * versionStr = @"";
    if (self.payDetailDic[@"version"]) {
        versionStr = self.payDetailDic[@"version"];
    }
    if (isSuccess) {
        params = @{@"action":@"invoke",
                   @"desc":@"SUCCESS",
                   @"error":@0,
                   @"result":_hashString,
                   @"version":versionStr,
                   @"id":idStr
                   };
    }else{
        params = @{@"action":@"invoke",
                   @"desc":@"SEND TX ERROR",
                   @"error":@8001,
                   @"result":@1,
                   @"version":versionStr,
                   @"id":idStr
                   };
    }
    [[CCRequest shareInstance]requestWithURLString:_callback MethodType:MethodTypePOST Params:params Success:^(id responseObject, id responseOriginal) {
        
    } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
        
    }];
}
-(void)configUI{
    [self.view addSubview:self.browserView];
    
    UILabel * feeLB = [[UILabel alloc]init];
//    feeLB.text = @"svdfsdfsdfsf";
//    feeLB.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    feeLB.numberOfLines = 0;
    feeLB.attributedText = [self getFeeString];
    [feeLB changeSpace:0 wordSpace:1];
    feeLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:feeLB];
    
    UILabel * fromLB = [[UILabel alloc]init];
    fromLB.text = @"FROM";
    fromLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [fromLB changeSpace:0 wordSpace:1];
    fromLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:fromLB];
    
    UILabel * nameLB = [[UILabel alloc]init];
    nameLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    nameLB.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    nameLB.text = _defaultDic[@"label"];
    [nameLB changeSpace:0 wordSpace:1];
    nameLB.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:nameLB];
    
    UILabel * addressLB = [[UILabel alloc]init];
    addressLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    addressLB.textColor = [UIColor colorWithHexString:@"#000000"];
    addressLB.text = _defaultDic[@"address"];
    addressLB.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:addressLB];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:line];
    
    UILabel * toLB = [[UILabel alloc]init];
    toLB.text = @"TO";
    toLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [toLB changeSpace:0 wordSpace:1];
    toLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:toLB];
    
    UILabel * toAddressLB = [[UILabel alloc]init];
    toAddressLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    toAddressLB.textColor = [UIColor colorWithHexString:@"#000000"];
    toAddressLB.text = _toAddress;
    toAddressLB.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:toAddressLB];
    
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:line1];
    
    UIButton * confirmBtn = [[UIButton alloc]init];
    confirmBtn.backgroundColor = BUTTONBACKCOLOR;
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [confirmBtn.titleLabel changeSpace:0 wordSpace:3];
    [self.view addSubview:confirmBtn];
    
    [confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"111");
        self.hub=[ToastUtil showMessage:@"" toView:nil];
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",self.hashString];
        LOADJS1;
        LOADJS2;
        LOADJS3;
        __weak typeof(self) weakSelf = self;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        [self.browserView setCallbackPrompt:^(NSString * prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }];
    
    [feeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.view).offset(30*SCALE_W);
    }];
    
    [fromLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.top.equalTo(feeLB.mas_bottom).offset(48*SCALE_W);
    }];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fromLB);
        make.top.equalTo(fromLB.mas_bottom).offset(12*SCALE_W);
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fromLB);
        make.top.equalTo(nameLB.mas_bottom).offset(6*SCALE_W);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(addressLB.mas_bottom).offset(18*SCALE_W);
        make.height.mas_offset(1);
    }];
    
    [toLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fromLB);
        make.top.equalTo(line.mas_bottom).offset(28*SCALE_W);
    }];
    
    [toAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fromLB);
        make.top.equalTo(toLB.mas_bottom).offset(12*SCALE_W);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(toAddressLB.mas_bottom).offset(18*SCALE_W);
        make.height.mas_offset(1);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        make.bottom.equalTo(self.view).offset(-100*SCALE_W);
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
-(NSMutableAttributedString*)getFeeString{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]init];
    [string appendAttributedString:[self appendColorStrWithString:@"You will pay " font:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium] color:[UIColor colorWithHexString:@"#000000" ]]];
    [string appendAttributedString:[self appendColorStrWithString:[NSString stringWithFormat:@"%@",_payMoney] font:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium] color:[UIColor colorWithHexString:@"#196BD8" ]]];
    [string appendAttributedString:[self appendColorStrWithString:self.isONT? @" ONT":@" ONG" font:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium] color:[UIColor colorWithHexString:@"#000000" ]]];
    return string;
}
-(NSMutableAttributedString*)appendColorStrWithString:(NSString*)String font:(UIFont*)font color:(UIColor*)color{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:String attributes:@{NSKernAttributeName :@0}];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, String.length)];
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, String.length)];
    return string;
    
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
