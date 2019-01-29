//
//  Oep4TokensViewController.m
//  cyano
//
//  Created by Apple on 2019/1/9.
//  Copyright © 2019 LR. All rights reserved.
//

#import "Oep4TokensViewController.h"
#import "UITextField+LKLUITextField.h"
#import "SendConfirmView.h"
#import "BrowserView.h"
@interface Oep4TokensViewController ()
<UITextFieldDelegate>
{
    BOOL isHaveDian;
}
@property(nonatomic,strong)UITextField * AmountLBNumField;
@property(nonatomic,strong)UITextField * addressField;
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,strong)BrowserView   *browserView;
@property(nonatomic,copy)  NSString      *confirmPwd;
@property(nonatomic,strong)MBProgressHUD *hub;
@property(nonatomic,strong)UILabel * amountLB;
@end

@implementation Oep4TokensViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *getNeoBalancejsStr =
    [NSString stringWithFormat:@"Ont.SDK.queryOep4Balance('%@','%@', 'queryOep4Balance')",_tokenDict[@"ContractHash"], _walletDict[@"address"]];
    
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:getNeoBalancejsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (void)handlePrompt:(NSString *)prompt {
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = [promptArray[1] dataUsingEncoding:NSUTF8StringEncoding];
    
    id obj = [NSJSONSerialization JSONObjectWithData:resultStr options:0 error:nil];
    
    if ([prompt hasPrefix:@"queryOep4Balance"]) {
        NSString * oep4Amount = [NSString stringWithFormat:@"%@",obj[@"result"]];
        NSString * oep4Ori =[Common changeOEP4Str:oep4Amount Decimals:[_tokenDict[@"Decimals"] intValue]];
        _amountLB.text = [Common getPrecision9Str:oep4Ori Decimal:[_tokenDict[@"Decimals"] intValue]];
    }else if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]){
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.confirmPwd = @"";
            [Common showToast:@"Password error"];
        }else{
            [self createTrade];
        }
    }else if ([prompt hasPrefix:@"transferOep4"]){
        NSLog(@"transferOep4=%@",prompt);
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            [Common showToast:[NSString stringWithFormat:@"%@:%@", Localized(@"Systemerror"), [obj valueForKey:@"error"]]];
            return;
        }else{
            [self sendTrade:obj[@"tx"]];
        }
    }else if ([prompt hasPrefix:@"sendTransaction"]) {
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            [Common showToast:@"The transaction has been issued."];
            [self.sendConfirmV dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([[obj valueForKey:@"error"] integerValue] > 0) {
                [Common showToast:[NSString stringWithFormat:@"%@:%@",@"System error",[obj valueForKey:@"error"]]];
                return;
            }
        }
    }
}
- (void)sendTrade:(NSString*)tx{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",tx];
    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    
}
-(void)createTrade{
    NSString * CodeHash = self.tokenDict[@"ContractHash"];
    NSString * sendvalue = [Common getOEP4Str:_AmountLBNumField.text Decimals:[self.tokenDict[@"Decimals"] intValue] ];;
    NSString * encryptedPrivateKey = self.walletDict[@"key"];
    NSString * jsUrl = [NSString stringWithFormat:@"Ont.SDK.transferOep4('%@','%@','%@','%@','%@','%@','%@','%@','%@','transferOep4')",
                                         CodeHash,
                                         self.walletDict[@"address"],
                                         _addressField.text,
                                         sendvalue,
                                         encryptedPrivateKey,
                                         [Common transferredMeaning:_confirmPwd],
                                         self.walletDict[@"salt"],
                                         [Common getPrecision9Str:@"500"],
                                         [Common getPrecision9Str:@"20000"]];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsUrl completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}
- (void)loadJS{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.walletDict[@"key"],[Common transferredMeaning:_confirmPwd],self.walletDict[@"address"],self.walletDict[@"salt"]];
    
    if (_confirmPwd.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}
-(void)createUI{
    [self.view addSubview:self.browserView];
    self.view.backgroundColor = TABLEBACKCOLOR;
    
    UIView * topV = [[UIView alloc]init];
    topV.backgroundColor = BLUELB;
    [self.view addSubview:topV];
    
    _amountLB = [[UILabel alloc]init];
    _amountLB.textColor = WHITE;
    _amountLB.textAlignment = NSTextAlignmentLeft;
    _amountLB.font = [UIFont systemFontOfSize:16];
    _amountLB.numberOfLines = 0;
    [topV addSubview:_amountLB];
    
    UILabel * RecipientLB = [[UILabel alloc]init];
    RecipientLB.text = @"Recipient";
    RecipientLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:RecipientLB];
    
    _addressField = [[UITextField alloc]init];
    _addressField.backgroundColor = WHITE;
    [_addressField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    _addressField.font = [UIFont systemFontOfSize:14];
    _addressField.layer.borderWidth = 1;
    _addressField.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:_addressField];
    
    
    UILabel * AmountLB = [[UILabel alloc]init];
    AmountLB.text = @"Amount";
    AmountLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:AmountLB];
    
    _AmountLBNumField = [[UITextField alloc]init];
    _AmountLBNumField.keyboardType = UIKeyboardTypeDecimalPad;
    _AmountLBNumField.backgroundColor = WHITE;
    _AmountLBNumField.delegate = self;
    [_AmountLBNumField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    _AmountLBNumField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _AmountLBNumField.layer.borderWidth = 1;
    _AmountLBNumField.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:_AmountLBNumField];
    
    UIButton * confirmBtn = [[UIButton alloc]init];
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [confirmBtn.titleLabel changeSpace:0 wordSpace:1];
    confirmBtn.backgroundColor = BUTTONBACKCOLOR;
    [confirmBtn addTarget:self action:@selector(confirmInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    [_amountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.view).offset(20*SCALE_W);
        make.bottom.equalTo(topV.mas_bottom).offset(-40*SCALE_W);
    }];
    
    [RecipientLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(topV.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(RecipientLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [AmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(self.addressField.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_AmountLBNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(AmountLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34 - 40);
        }else{
            make.bottom.equalTo(self.view).offset(- 40);
            
        }
    }];
}

-(void)confirmInfo{
    [_AmountLBNumField resignFirstResponder];
    [_addressField resignFirstResponder];
    if (_addressField.text.length != 34 || ![[self firstCharactorWithString:_addressField.text] isEqualToString:@"A"]) {
        [Common showToast:@"Recipient's address is invalid."];
        return;
    }
    
    if ([Common isStringEmpty:_addressField.text] || [Common isStringEmpty:_AmountLBNumField.text]) {
        return;
    }
    
    NSDecimalNumber
    *decimalFee = [[NSDecimalNumber alloc] initWithString:[Common getRealFee:@"500" GasLimit:@"20000"]];;
    NSDecimalNumber *decimalSend = [[NSDecimalNumber alloc] initWithString:_AmountLBNumField.text];
    NSDecimalNumber *decimalAmount = [[NSDecimalNumber alloc] initWithString:_amountLB.text];
    
    // 这里比较ONG或者ONT发送的总量是否大于余额
    NSComparisonResult resultOfBalanceAndAmount = [decimalSend compare:decimalAmount];
    if (resultOfBalanceAndAmount == NSOrderedDescending) {
        [Common showToast:@"The amount of the transfer is greater than the total amount."];
        return;
    }
    NSDecimalNumber *decimalCost = nil;
    if (!_isONT) {
        decimalCost = [decimalSend decimalNumberByAdding:decimalFee];
    } else {
        decimalCost = decimalFee;
    }
    NSDecimalNumber *decimalOngAmount = [[NSDecimalNumber alloc] initWithString:_ongNum];
    
    // 这里是比较ong是否足够，如果是发送ong，那么就要把ong手续费和发送的ong加起来和ong余额比较
    NSComparisonResult resultOfCostAndOngAmount = [decimalCost compare:decimalOngAmount];
    if (resultOfCostAndOngAmount == NSOrderedDescending) {
        [Common showToast:@"Not enough ONG to make the transaction."];
        return;
    }
    
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}
- (void)createNav{
    self.view.backgroundColor = WHITE;
    [self setNavTitle:self.tokenDict[@"Symbol"]];
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
- (SendConfirmView *)sendConfirmV {
    
    if (!_sendConfirmV) {
        
        _sendConfirmV = [[SendConfirmView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, kScreenHeight)];
        __weak typeof(self) weakSelf = self;
        [_sendConfirmV setCallback:^(NSString *token, NSString *from, NSString *to, NSString *value, NSString *password) {
            weakSelf.confirmPwd = password;
            [weakSelf loadJS];
        }];
    }
    return _sendConfirmV;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if ([textField.text length] == 0) {
                if (single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (!_isOEP4) {
                    if (single == '0') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                
                if (!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                } else {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (_isOEP4) {
                        if (range.location - ran.location <= [self.tokenDict[@"Decimals"]intValue] ) {
                            return YES;
                        } else {
                            return NO;
                        }
                    }else{
                        if (range.location - ran.location <= 9) {
                            return YES;
                        } else {
                            return NO;
                        }
                    }
                    
                } else {
                    return YES;
                }
            }
        } else {//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}
- (BOOL)validateNumber:(NSString *)number {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//获取某个字符串或者汉字的首字母.
- (NSString *)firstCharactorWithString:(NSString *)string {
    
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
    
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
