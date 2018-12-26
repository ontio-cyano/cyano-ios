//
//  ImportWalletViewController.m
//  cyano
//
//  Created by Apple on 2018/12/25.
//  Copyright © 2018 LR. All rights reserved.
//

#import "ImportWalletViewController.h"

@interface ImportWalletViewController ()
<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITextView * importTextView;
@property(nonatomic,strong)UITextField* nameField;
@property(nonatomic,strong)UITextField* pwdField;
@property(nonatomic,strong)MBProgressHUD *hub;
@end

@implementation ImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}
-(void)configUI{
    UIButton * WIFImportBtn = [[UIButton alloc]init];
    [WIFImportBtn setTitle:@"WIF" forState:UIControlStateNormal];
    [WIFImportBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    WIFImportBtn.backgroundColor = BUTTONBACKCOLOR   ;
    [self.view addSubview:WIFImportBtn];
    
    UIButton * PrikeyImportBtn = [[UIButton alloc]init];
    [PrikeyImportBtn setTitle:@"Private key" forState:UIControlStateNormal];
    [PrikeyImportBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    PrikeyImportBtn.backgroundColor = BUTTONBACKCOLOR   ;
    [self.view addSubview:PrikeyImportBtn];
    
    _importTextView = [[UITextView alloc]init];
    _importTextView.backgroundColor = BUTTONBACKCOLOR;
    _importTextView.layer.cornerRadius = 3;
    [self.view addSubview:_importTextView];
    
    UILabel * walletName = [[UILabel alloc]init];
    walletName.text = @"Wallet Name";
    [self.view addSubview:walletName];
    
    _nameField = [[UITextField alloc]init];
    _nameField.layer.borderWidth = 0.5;
    _nameField.font = [UIFont systemFontOfSize:14];
    _nameField.placeholder  = @"Only letters and numbers are accepted";
    _nameField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [self.view addSubview:_nameField];
    
    UILabel * pwdLB = [[UILabel alloc]init];
    pwdLB.text = @"Password";
    [self.view addSubview:pwdLB];
    
    _pwdField = [[UITextField alloc]init];
    _pwdField.font = [UIFont systemFontOfSize:14];
    _pwdField.layer.borderWidth = 0.5;
    _pwdField.placeholder   = @"Please enter password";
    _pwdField.delegate = self;
    _pwdField.secureTextEntry = YES;
    _pwdField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [_pwdField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.view addSubview:_pwdField];
    
    UIButton * importBtn = [[UIButton alloc]init];
    importBtn.backgroundColor = BUTTONBACKCOLOR ;
    [importBtn setTitle:@"IMPORT" forState:UIControlStateNormal];
    [importBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    importBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [importBtn.titleLabel changeSpace:0 wordSpace:2];
    [self.view addSubview:importBtn];
    
    [importBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"111");
    }];
    
    [WIFImportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view.mas_centerX).offset(-20*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.top.equalTo(self.view).offset(30*SCALE_W);
    }];
    
    [PrikeyImportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(20*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.view).offset(30*SCALE_W);
    }];
    
    [_importTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.height.mas_offset(140*SCALE_W);
        make.top.equalTo(PrikeyImportBtn.mas_bottom).offset(30*SCALE_W);
    }];
    
    [WIFImportBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        WIFImportBtn.backgroundColor = [UIColor lightGrayColor];
        PrikeyImportBtn.backgroundColor = BUTTONBACKCOLOR;
        if (!self.isWIF) {
            self.importTextView.text = @"";
        }
        self.isWIF = YES;
    }];
    
    [PrikeyImportBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        WIFImportBtn.backgroundColor = BUTTONBACKCOLOR ;
        PrikeyImportBtn.backgroundColor = [UIColor lightGrayColor];
        if (self.isWIF) {
            self.importTextView.text = @"";
        }
        self.isWIF = NO;
    }];
    
    [importBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (self.isWIF) {
            if (self.importTextView.text.length !=52) {
                [Common showToast:@"Failed to import ! Please input 52 characters ."];
                return ;
            }
        }else{
            if (self.importTextView.text.length !=64) {
                [Common showToast:@"Failed to import ! Please input 64 characters."];
                return;
            }
        }
        if (self.nameField.text.length <= 0 || self.nameField.text.length > 12) {
            [Common showToast:@"Please enter a wallet name (1-12 characters)"];
            return;
        }
        if (![AppHelper checkName:self.nameField.text]) {
            [Common showToast:@"Only letters and numbers are accepted"];
            return;
        }
        
        [self toImportWallet];
    }];
    
    [walletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.importTextView.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.top.equalTo(walletName.mas_bottom).offset(15*SCALE_W);
    }];
    
    [pwdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.nameField.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.top.equalTo(pwdLB.mas_bottom).offset(15*SCALE_W);
    }];
    
    [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        make.bottom.equalTo(self.view).offset(-60*SCALE_W);
    }];
}
-(void)toImportWallet{
    NSString *jsurl ;
    _hub=[ToastUtil showMessage:@"" toView:nil];
    if (_isWIF){
        jsurl = [NSString stringWithFormat:@"Ont.SDK.importAccountWithWif('%@','%@','%@','importAccountWithWif')",self.nameField.text,self.importTextView.text,[Common transferredMeaning:self.pwdField.text]];
    }else{
        jsurl = [NSString stringWithFormat:@"Ont.SDK.importAccountWithPrivateKey('%@','%@','%@','importAccountWithPrivateKey')",self.nameField.text,self.importTextView.text,[Common transferredMeaning:self.pwdField.text]];
    }
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsurl completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
    __weak typeof(self) weakSelf = self;
    
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (void)handlePrompt:(NSString *)prompt {
    DebugLog(@"prompt%@",prompt);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"importAccountWithWif"] || [prompt hasPrefix:@"importAccountWithPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [_hub hideAnimated:YES];
            NSMutableString *str=[obj valueForKey:@"result"];
            NSDictionary *jsDic= [Common dictionaryWithJsonString:str];
            DebugLog(@"~~~~~~~~%@",[obj valueForKey:@"result"]);
            
            NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
            NSMutableArray *newArray;
            if (allArray) {
                newArray = [[NSMutableArray alloc] initWithArray:allArray];
            } else {
                newArray = [[NSMutableArray alloc] init];
            }
            //防止重复添加
            for (int i=0; i<allArray.count; i++) {
                if ( [[allArray[i] valueForKey:@"address"]isEqualToString:[jsDic valueForKey:@"address"]]) {
                    
                    [Common showToast:@"The digital wallet is already in ONTO now"];
                    
                    return;
                }
            }
            
            
            //       [jsDic setValue:self.nameF.text forKey:@"label"];
            [newArray addObject:jsDic];
            [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:ALLASSET_ACCOUNT];
            
            NSString *jsonStr = [Common  dictionaryToJson:newArray[newArray.count-1]];
            [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:ASSET_ACCOUNT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Common showToast:@"succeed"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
        
    
    
}
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
    }
    
}
// 导航栏设置
- (void)configNav {
    self.view.backgroundColor = WHITE;
    [self setNavTitle:@"Import Wallet"];
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
