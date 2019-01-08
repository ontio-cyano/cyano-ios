//
//  MineViewController.m
//  cyano
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "MineViewController.h"
#import "ExportWalletViewController.h"
#import "SendConfirmView.h"
#import "ChangeNodeViewController.h"
#import "ExportIdentityViewController.h"
@interface MineViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,strong)BrowserView *browserView;
@property(nonatomic,strong)MBProgressHUD *hub;
@property(nonatomic,copy)  NSString *confirmPwd;
@property(nonatomic,strong)NSDictionary* defaultDic;
@property(nonatomic,strong)NSDictionary* defaultIdentityDic;
@property(nonatomic,assign)BOOL isIdentity;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNav];
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
- (void)loadPswJS{
    if (self.isIdentity) {
        [self loadPswJsByIdentity];
    }else{
        [self loadPswJsByWallet];
    }
    
    
}
-(void)loadPswJsByWallet{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    if (dict.count == 0) {
        return;
    }
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",dict[@"key"],[Common transferredMeaning:_confirmPwd],dict[@"address"],dict[@"salt"]];
    
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
-(void)loadPswJsByIdentity{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:APP_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    NSDictionary *controlsDic = dict[@"controls"][0];
    self.defaultIdentityDic = controlsDic;
    if (dict.count == 0) {
        return;
    }
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptByIdentity')",controlsDic[@"key"],[Common transferredMeaning:_confirmPwd],controlsDic[@"address"],controlsDic[@"salt"]];

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
            NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.exportWifPrivakeKey('%@','%@','%@','%@','exportWifPrivakeKey')",self.defaultDic[@"key"],[Common transferredMeaning:_confirmPwd],self.defaultDic[@"address"],self.defaultDic[@"salt"]];
            
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
    }else if ([prompt hasPrefix:@"decryptByIdentity"]) {
        NSLog(@"identity=%@",obj);
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.confirmPwd = @"";
            [Common showToast:@"Password error"];
        }else{
            [self.sendConfirmV dismiss];
                NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.exportWifPrivakeKey('%@','%@','%@','%@','exportWifByIdentity')",self.defaultIdentityDic[@"key"],[Common transferredMeaning:_confirmPwd],self.defaultIdentityDic[@"address"],self.defaultIdentityDic[@"salt"]];
            
            if (_confirmPwd.length==0) {
                return;
            }
            [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            __weak typeof(self) weakSelf = self;
            [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
                [weakSelf handlePrompt:prompt];
            }];
        }
    }else if ([prompt hasPrefix:@"exportWifByIdentity"]) {
        [_hub hideAnimated:YES];
        NSDictionary *resultDic = obj[@"result"];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            ExportIdentityViewController * vc = [[ExportIdentityViewController alloc]init];
            vc.wifString = resultDic[@"wif"];
            vc.keyString = resultDic[@"privateKey"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)createUI{
    [self.view addSubview:self.browserView];
    [self.view addSubview:self.sendConfirmV];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-88);
        }else{
            make.bottom.equalTo(self.view).offset(-49);
        }
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BUTTONBACKCOLOR  ;
        [cell.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10*SCALE_W);
            make.right.equalTo(cell.contentView).offset(-10*SCALE_W);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-1);
            make.height.mas_offset(1);
        }];
        
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"SELECT NODE";
    }else if (indexPath.row ==1){
        cell.textLabel.text = @"CLEAR WALLET";
    }else if (indexPath.row ==2){
        cell.textLabel.text = @"EXPORT WALLET";
    }else if (indexPath.row ==3){
        cell.textLabel.text = @"CLEAR IDENTITY";
    }else if (indexPath.row ==4){
        cell.textLabel.text = @"EXPORT IDENTITY";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    cell.textLabel.textColor = BLUELB;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChangeNodeViewController * vc = [[ChangeNodeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ALLASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (indexPath.row == 2){
        [self toExportWallet];
    }else if (indexPath.row == 3){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:APP_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (indexPath.row == 4){
        [self toExportIdentity];
    }
}
-(void)toExportIdentity{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:APP_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No identity"];
        return;
    }
    self.isIdentity = YES;
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}
-(void)toExportWallet{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No Wallet"];
        return;
    }
    self.isIdentity = NO;
    self.defaultDic = [Common dictionaryWithJsonString:jsonStr];
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}
-(void)createNav{
    self.view.backgroundColor = TABLEBACKCOLOR;
    [self setNavTitle:@"Settings"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"smallLogo"] Title:@""];
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
