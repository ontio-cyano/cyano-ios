//
//  SendViewController.m
//  cyano
//
//  Created by Apple on 2018/12/23.
//  Copyright © 2018 LR. All rights reserved.
//

#import "SendViewController.h"
#import "UITextField+LKLUITextField.h"
#import "SendConfirmView.h"
#import "BrowserView.h"
@interface SendViewController ()
<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isHaveDian;
}
@property(nonatomic,strong)UITextField * AssetTypeField;
@property(nonatomic,strong)UITextField * AmountLBNumField;
@property(nonatomic,strong)UITextField * addressField;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,strong)BrowserView   *browserView;
@property(nonatomic,copy)  NSString      *confirmPwd;
@property(nonatomic,strong)MBProgressHUD *hub;
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
}
-(void)createUI{
    [self.view addSubview:self.browserView];
    self.view.backgroundColor = TABLEBACKCOLOR;
    
    UIView * topV = [[UIView alloc]init];
    topV.backgroundColor = BLUELB;
    [self.view addSubview:topV];
    
    UILabel * alertLB = [[UILabel alloc]init];
    alertLB.text = @"Double check the address of the recipient.";
    alertLB.textColor = WHITE;
    alertLB.textAlignment = NSTextAlignmentCenter;
    alertLB.font = [UIFont systemFontOfSize:16];
    alertLB.numberOfLines = 0;
    [topV addSubview:alertLB];
    
    UILabel * RecipientLB = [[UILabel alloc]init];
    RecipientLB.text = @"Recipient";
    RecipientLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:RecipientLB];
    
    _addressField = [[UITextField alloc]init];
//    _addressField.delegate = self;
    _addressField.backgroundColor = WHITE;
    [_addressField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    _addressField.font = [UIFont systemFontOfSize:14];
    _addressField.layer.borderWidth = 1;
    _addressField.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:_addressField];
    
    UILabel * AssetLB = [[UILabel alloc]init];
    AssetLB.text = @"Asset";
    AssetLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:AssetLB];
    
    _AssetTypeField = [[UITextField alloc]init];
    _AssetTypeField.enabled = NO;
    _AssetTypeField.text = @"ONT";
    _AssetTypeField.backgroundColor = WHITE;
    [_AssetTypeField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    _AssetTypeField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    _AssetTypeField.layer.borderWidth = 1;
    _AssetTypeField.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:_AssetTypeField];
    
    UIButton * changeBtn = [[UIButton alloc]init];
    [self.view addSubview:changeBtn];
    
    UIImageView * arrowImage = [[UIImageView alloc]init];
    arrowImage.image = [UIImage imageNamed:@"sDown"];
    [self.view addSubview:arrowImage];
    
    
    UILabel * AmountLB = [[UILabel alloc]init];
    AmountLB.text = @"Amount";
    AmountLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:AmountLB];
    
    _AmountLBNumField = [[UITextField alloc]init];
//    _AmountLBNumField.text = @"0";
    [_AmountLBNumField addTarget:self action:@selector(limit10Chars:) forControlEvents:UIControlEventEditingChanged];

    _AmountLBNumField.keyboardType = _isONT ? UIKeyboardTypeNumberPad : UIKeyboardTypeDecimalPad;
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
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [[UIColor blackColor]CGColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    [changeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (self.tableView.isHidden == YES) {
            self.tableView.hidden = NO;
        }else{
            self.tableView.hidden = YES;
        }
    }];
    
    
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    [alertLB mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [AssetLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(self.addressField.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_AssetTypeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(AssetLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(AssetLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(changeBtn);
        make.top.equalTo(self.AssetTypeField.mas_bottom).offset(-1);
        make.height.mas_offset(120*SCALE_W);
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(changeBtn.mas_centerY);
        make.width.height.mas_offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
    }];
    
    [AmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(self.AssetTypeField.mas_bottom).offset(20*SCALE_W);
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
        make.bottom.equalTo(self.view).offset(-100*SCALE_W);
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
    NSDecimalNumber *decimalAmount = [[NSDecimalNumber alloc] initWithString:_isONT ? _ontNum: _ongNum];
    
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
    [self setNavTitle:@"Send"];
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
// TS SDK 回调处理
- (void)handlePrompt:(NSString *)prompt{
    
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // 密码解密回调处理
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.confirmPwd = @"";
            [Common showToast:@"Password error"];
        }else{
            [self createTrade];
        }
    }else if ([prompt hasPrefix:@"transferAssets"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated: YES];
            [self.sendConfirmV dismiss];
            [Common showToast:[NSString stringWithFormat:@"%@:%@", @"System error", [obj valueForKey:@"error"]]];
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

-(void)createTrade{

    NSString *token = _isONT? @"ONT":@"ONG";
    
    NSString * moneyValue ;
    if (_isONT) {
        moneyValue = _AmountLBNumField.text;
    }else{
        moneyValue =  [Common getONGMul10_9Str:_AmountLBNumField.text];
    }
    NSString* jsStr  =  [NSString stringWithFormat
                         :@"Ont.SDK.transferAssets('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','transferAssets')",
                         token, _walletDict[@"address"], _addressField.text,
                         moneyValue,
                         _walletDict[@"key"],
                         [Common transferredMeaning:self.confirmPwd],
                         _walletDict[@"salt"],
                         [Common getPrecision9Str:@"500"],
                         [Common getPrecision9Str:@"20000"],
                         _walletDict[@"address"]];
    

    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (void)sendTrade:(NSString*)tx{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",tx];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:TESTNETADDR]);
    NSLog(@"SERVERNODE=%@",SERVERNODE);
    LOADJS1;
    LOADJS2;
    LOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UITextField * field = [[UITextField alloc]init];
        field.tag = 1001;
        field.enabled = NO;
        [field setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
        field.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [cell.contentView addSubview:field];
        
        UIView * line = [[UIView alloc]init];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
        
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(cell.contentView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_offset(1);
        }];
    }
    
    UITextField * assetField = [cell.contentView viewWithTag:1001];
    if (indexPath.row == 0) {
        assetField.text = @"ONT";
        if (self.isONT) {
            cell.backgroundColor = TABLEBACKCOLOR;
        }else{
            cell.backgroundColor = WHITE;
        }
    }else{
        assetField.text = @"ONG";
        if (self.isONT) {
            cell.backgroundColor = WHITE;
        }else{
            cell.backgroundColor = TABLEBACKCOLOR;
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _AssetTypeField.text = @"ONT";
        self.isONT = YES;
    }else{
        _AssetTypeField.text = @"ONG";
        self.isONT = NO;
    }
    _AmountLBNumField.keyboardType = _isONT ? UIKeyboardTypeNumberPad : UIKeyboardTypeDecimalPad;
    [_tableView reloadData];
    _tableView.hidden = YES;
}
- (void)limit10Chars:(UITextField *)textField {
    if (_isONT) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_isONT) {
        return [self validateNumber:string];
    }
    
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
                
                if (_isONT == YES) {
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
                    if (range.location - ran.location <= 9) {
                        return YES;
                    } else {
                        return NO;
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
