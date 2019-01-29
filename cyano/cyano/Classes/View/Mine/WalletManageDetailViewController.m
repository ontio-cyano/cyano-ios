//
//  WalletManageDetailViewController.m
//  cyano
//
//  Created by Apple on 2019/1/29.
//  Copyright © 2019 LR. All rights reserved.
//

#import "WalletManageDetailViewController.h"
#import "SendConfirmView.h"
#import "ExportWalletViewController.h"
@interface WalletManageDetailViewController ()
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,strong)BrowserView *browserView;
@property(nonatomic,strong)MBProgressHUD *hub;
@property(nonatomic,copy)  NSString *confirmPwd;
@property(nonatomic,assign)BOOL isDelete;
@end

@implementation WalletManageDetailViewController

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
-(void)loadPswJS{
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.walletDic[@"key"],[Common transferredMeaning:_confirmPwd],self.walletDic[@"address"],self.walletDic[@"salt"]];
    
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
- (void)handlePrompt:(NSString *)prompt{
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.confirmPwd = @"";
            [Common showToast:@"Password error"];
        }else{
            [self.sendConfirmV dismiss];
            if (self.isDelete) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ASSET_ACCOUNT];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ALLASSET_ACCOUNT];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.exportWifPrivakeKey('%@','%@','%@','%@','exportWifPrivakeKey')",self.walletDic[@"key"],[Common transferredMeaning:_confirmPwd],self.walletDic[@"address"],self.walletDic[@"salt"]];
            
            [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            __weak typeof(self) weakSelf = self;
            [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
                [weakSelf handlePrompt:prompt];
            }];
        }
    }else if ([prompt hasPrefix:@"exportWifPrivakeKey"]) {
        NSLog(@"wif=%@",prompt);
        [_hub hideAnimated:YES];
        NSDictionary *resultDic = obj[@"result"];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            ExportWalletViewController * vc = [[ExportWalletViewController alloc]init];
            vc.wifString = resultDic[@"wif"];
            vc.keyString = resultDic[@"privateKey"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)configUI{
    
    UIImageView * topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"shareTu"];
    [self.view addSubview:topImage];
    
    UILabel * addressLB = [[UILabel alloc]init];
    addressLB.textAlignment = NSTextAlignmentCenter;
    addressLB.lineBreakMode = NSLineBreakByTruncatingMiddle;
    addressLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    addressLB.text = self.walletDic[@"address"];
    [self.view addSubview:addressLB];
    
    UIButton * setButton = [[UIButton alloc]init];
    [setButton setTitle:@"SET DEFAULT" forState:UIControlStateNormal];
    [setButton setTitleColor:BLUELB forState:UIControlStateNormal];
    setButton.backgroundColor = BUTTONBACKCOLOR;
    setButton.layer.cornerRadius = 3;
    setButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:setButton];
    
    UIButton * exportButton = [[UIButton alloc]init];
    [exportButton setTitle:@"EXPORT WALLET" forState:UIControlStateNormal];
    [exportButton setTitleColor:BLUELB forState:UIControlStateNormal];
    exportButton.backgroundColor = BUTTONBACKCOLOR;
    exportButton.layer.cornerRadius = 3;
    exportButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:exportButton];
    
    UIButton * deleteButton = [[UIButton alloc]init];
    [deleteButton setTitle:@"DELETE WALLET" forState:UIControlStateNormal];
    [deleteButton setTitleColor:BLUELB forState:UIControlStateNormal];
    deleteButton.backgroundColor = BUTTONBACKCOLOR;
    deleteButton.layer.cornerRadius = 3;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:deleteButton];
    
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.width.height.mas_offset(50);
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(topImage.mas_bottom).offset(20);
    }];
    
    
    [setButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString *jsonStr = [Common dictionaryToJson:self.walletDic];
        [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    [exportButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.isDelete = NO;
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
    }];
    
    [deleteButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.isDelete = YES;
        self.sendConfirmV.paybyStr = @"";
        self.sendConfirmV.amountStr = @"";
        self.sendConfirmV.isWalletBack = YES;
        [self.sendConfirmV show];
        
    }];
    
    if (self.isDefault) {
        [exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(addressLB.mas_bottom).offset(40);
            make.height.mas_offset(40);
        }];
    }else{
        [setButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(addressLB.mas_bottom).offset(40);
            make.height.mas_offset(40);
        }];
        
        [exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(setButton.mas_bottom).offset(20);
            make.height.mas_offset(40);
        }];
        
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(exportButton.mas_bottom).offset(20);
            make.height.mas_offset(40);
        }];
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
