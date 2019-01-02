//
//  CreateIdentityViewController.m
//  cyano
//
//  Created by Apple on 2019/1/2.
//  Copyright © 2019 LR. All rights reserved.
//

#import "CreateIdentityViewController.h"
#import "UITextField+LKLUITextField.h"
#import "BrowserView.h"
#import "SendConfirmView.h"
@interface CreateIdentityViewController ()
<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * pwdField;
@property(nonatomic,strong)UITextField * pwdAgainField;
@property(nonatomic,strong)BrowserView * browserView;

@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,copy)  NSString *confirmPwd;
@property(nonatomic,copy)  NSMutableString *identityString;
@end

@implementation CreateIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
    
}

- (void)createUI{
    UILabel *alertLB = [[UILabel alloc]init];
    alertLB.textColor = [UIColor whiteColor];
    alertLB.numberOfLines = 0;
    alertLB.text = @"Enter your passphrase for identity encryption.\n Registration will cost you 0.01 ONG.";
    alertLB.font = [UIFont systemFontOfSize:16];
    alertLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLB];
    
    UIView *bottomV = [[UIView alloc]init];
    bottomV.backgroundColor = TABLEBACKCOLOR;
    [self.view addSubview:bottomV];
    
    UILabel *pwdLB = [[UILabel alloc]init];
    pwdLB.textAlignment = NSTextAlignmentLeft;
    pwdLB.text = @"Identity password";
    pwdLB.textColor = LBCOLOR;
    pwdLB.font = [UIFont systemFontOfSize:16];
    [bottomV addSubview:pwdLB];
    
    _pwdField = [[UITextField alloc]init];
    _pwdField.delegate = self;
    _pwdField.secureTextEntry = YES;
    _pwdField.layer.borderWidth = 1;
    _pwdField.layer.borderColor = [[UIColor colorWithHexString:@"#dededf"]CGColor];
    _pwdField.backgroundColor = WHITE;
    [_pwdField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    [bottomV addSubview:_pwdField];
    
    UILabel *pwdAgainLB = [[UILabel alloc]init];
    pwdAgainLB.textAlignment = NSTextAlignmentLeft;
    pwdAgainLB.text = @"Identity password again";
    pwdAgainLB.textColor = LBCOLOR;
    pwdAgainLB.font = [UIFont systemFontOfSize:16];
    [bottomV addSubview:pwdAgainLB];
    
    _pwdAgainField = [[UITextField alloc]init];
    _pwdAgainField.delegate = self;
    _pwdAgainField.secureTextEntry = YES;
    _pwdAgainField.layer.borderWidth = 1;
    _pwdAgainField.layer.borderColor = [[UIColor colorWithHexString:@"#dededf"]CGColor];
    _pwdAgainField.backgroundColor = WHITE;
    [_pwdAgainField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    [bottomV addSubview:_pwdAgainField];
    
    UIButton * signButton = [[UIButton alloc]init];
    [signButton setTitle:@"CREATE" forState:UIControlStateNormal];
    [signButton setTitleColor:BLUELB forState:UIControlStateNormal];
    signButton.backgroundColor = BUTTONBACKCOLOR;
    signButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [signButton addTarget:self action:@selector(createWallet) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:signButton];
    
    UIButton * cancelButton = [[UIButton alloc]init];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton setTitleColor:BLUELB forState:UIControlStateNormal];
    cancelButton.backgroundColor = BUTTONBACKCOLOR;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [bottomV addSubview:cancelButton];
    
    [self.view addSubview:self.browserView];
    
    [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(40*SCALE_W);
    }];
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertLB.mas_bottom).offset(40*SCALE_W);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [pwdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV).offset(10*SCALE_W);
        make.top.equalTo(bottomV).offset(15*SCALE_W);
    }];
    
    [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV).offset(10*SCALE_W);
        make.right.equalTo(bottomV).offset(-10*SCALE_W);
        make.top.equalTo(pwdLB.mas_bottom).offset(5*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
    }];
    
    [pwdAgainLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV).offset(10*SCALE_W);
        make.top.equalTo(self.pwdField.mas_bottom).offset(15*SCALE_W);
    }];
    
    [_pwdAgainField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV).offset(10*SCALE_W);
        make.right.equalTo(bottomV).offset(-10*SCALE_W);
        make.top.equalTo(pwdAgainLB.mas_bottom).offset(5*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
    }];
    
    [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomV).offset(-60*SCALE_W);
        make.width.mas_offset(140*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.right.equalTo(bottomV.mas_centerX).offset(-2*SCALE_W);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomV).offset(-60*SCALE_W);
        make.width.mas_offset(140*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.left.equalTo(bottomV.mas_centerX).offset(2*SCALE_W);
    }];
    
}
- (void)createNav{
    [self setNavTitle:@"New account"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:@""];
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
    // 密码解密回调处理
    
    if ([prompt hasPrefix:@"createIdentity"]) {
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [SVProgressHUD dismiss];
            [Common showToast:@"failed"];
            return;
        }else{
            [self sendTrade:obj[@"tx"]];
        }
        self.identityString = obj[@"result"];

    }else if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]){
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [SVProgressHUD dismiss];
            self.confirmPwd = @"";
            [Common showToast:@"Password error"];
        }else{
            [self.sendConfirmV dismiss];
            [self createIdentity];
        }
    }else if ([prompt hasPrefix:@"sendTransaction"]){
        [SVProgressHUD dismiss];
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
                    NSMutableString *str =self.identityString;
                    NSMutableString *appStr1 = [NSMutableString stringWithString:str];
                    [[NSUserDefaults standardUserDefaults] setObject:[appStr1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:APP_ACCOUNT];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [Common showToast:@"succeed"];
                    [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            if ([[obj valueForKey:@"error"] integerValue] > 0) {
                [Common showToast:[NSString stringWithFormat:@"%@:%@",@"System error",[obj valueForKey:@"error"]]];
                
            }
            
        }
    }
}
-(void)sendTrade:(NSString*)tx{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",tx];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    __weak typeof(self) weakSelf = self;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    [self.browserView setCallbackPrompt:^(NSString * prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
-(void)createIdentity{
    NSString * jsStr = jsStr = [NSString stringWithFormat:@"Ont.SDK.createIdentity('%@','%@','%@','%@','%@','createIdentity')",
                                @"",
                                self.pwdField.text,
                                _walletDic[@"address"],
                                [[NSUserDefaults standardUserDefaults] valueForKey:ONTIDGASPRICE],
                                [[NSUserDefaults standardUserDefaults] valueForKey:ONTIDGASLIMIT]];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    __weak typeof(self) weakSelf = self;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    [self.browserView setCallbackPrompt:^(NSString * prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (void)createWallet{

    if ([self.pwdField.text isEqualToString:self.pwdAgainField.text]) {
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
        
       
    }else{
        [Common showToast:@"The passwords do not match"];
    }
}
- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            weakSelf.confirmPwd = password;
            [weakSelf loadPswJS];
        }];
    }
    return _sendConfirmV;
}
- (void)loadPswJS{
    
    [SVProgressHUD show];
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.walletDic[@"key"],[Common transferredMeaning:_confirmPwd],self.walletDic[@"address"],self.walletDic[@"salt"]];
    
    if (_confirmPwd.length==0) {
        return;
    }
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}
- (void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
- (NSString *)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        DebugLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
