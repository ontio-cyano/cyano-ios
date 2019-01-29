//
//  CreateWalletViewController.m
//  cyano
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "UITextField+LKLUITextField.h"
#import "BrowserView.h"
@interface CreateWalletViewController ()
<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * pwdField;
@property(nonatomic,strong)UITextField * pwdAgainField;
@property(nonatomic,strong)BrowserView * browserView;
@end

@implementation CreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
    
}

- (void)createUI{
    UILabel *alertLB = [[UILabel alloc]init];
    alertLB.textColor = [UIColor whiteColor];
    alertLB.numberOfLines = 0;
    alertLB.text = @"Enter your passphrase for account encryption.";
    alertLB.font = [UIFont systemFontOfSize:16];
    alertLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLB];
    
    UIView *bottomV = [[UIView alloc]init];
    bottomV.backgroundColor = TABLEBACKCOLOR;
    [self.view addSubview:bottomV];
    
    UILabel *pwdLB = [[UILabel alloc]init];
    pwdLB.textAlignment = NSTextAlignmentLeft;
    pwdLB.text = @"Password";
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
    pwdAgainLB.text = @"Password again";
    pwdAgainLB.textColor = LBCOLOR;
    pwdAgainLB.font = [UIFont systemFontOfSize:16];
    [bottomV addSubview:pwdAgainLB];
    
    _pwdAgainField = [[UITextField alloc]init];
    _pwdAgainField.delegate = self;
    _pwdAgainField.layer.borderWidth = 1;
    _pwdAgainField.secureTextEntry = YES;
    _pwdAgainField.layer.borderColor = [[UIColor colorWithHexString:@"#dededf"]CGColor];
    _pwdAgainField.backgroundColor = WHITE;
    [_pwdAgainField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    [bottomV addSubview:_pwdAgainField];
    
    UIButton * signButton = [[UIButton alloc]init];
    [signButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
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
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
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
        make.width.mas_offset(140*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.right.equalTo(bottomV.mas_centerX).offset(-2*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(bottomV).offset(-34 - 40);
        }else{
            make.bottom.equalTo(bottomV).offset(- 40);
            
        }
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(140*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.left.equalTo(bottomV.mas_centerX).offset(2*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(bottomV).offset(-34 - 40);
        }else{
            make.bottom.equalTo(bottomV).offset(- 40);
            
        }
        
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
    [SVProgressHUD dismiss];
    if ([prompt hasPrefix:@"getAssetAccountDataStr"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            
            [Common showToast:@"failed"];
            return;
        }
        NSMutableString *str=[obj valueForKey:@"result"];
        
        NSDictionary *jsDic= [self parseJSONStringToNSDictionary:str];
        
        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        [newArray addObject:jsDic];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
        
        NSString *jsonStr = [Common  dictionaryToJson:newArray[newArray.count-1]];
        [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Common showToast:@"succeed"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createWallet{
//    if (self.pwdField.text.length > 15||self.pwdAgainField.text.length > 15|| self.pwdField.text.length < 8||self.pwdAgainField.text.length <8) {
//        [Common showToast:@"Please enter 8-15 characters for password"];
//        return;
//    }
    if ([self.pwdField.text isEqualToString:self.pwdAgainField.text]) {
        [SVProgressHUD show];
       NSString * jsStr = [NSString stringWithFormat:@"Ont.SDK.createAccount('%@','%@','getAssetAccountDataStr')",@"",[Common transferredMeaning:self.pwdField.text]];
        LOADJS1;
        LOADJS2;
        LOADJS3;
        __weak typeof(self) weakSelf = self;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
        [self.browserView setCallbackPrompt:^(NSString * prompt) {
            [weakSelf handlePrompt:prompt];
        }];
    }else{
        [Common showToast:@"The passwords do not match"];
    }
}
- (void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
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
