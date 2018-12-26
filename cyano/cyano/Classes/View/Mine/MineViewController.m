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
@interface MineViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,strong)BrowserView *browserView;
@property(nonatomic,strong)MBProgressHUD *hub;
@property(nonatomic,copy)  NSString *confirmPwd;
@property(nonatomic,strong)NSDictionary* defaultDic;
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
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            ExportWalletViewController * vc = [[ExportWalletViewController alloc]init];
            vc.wifString = obj[@"result"];
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"SELECT NODE";
    }else if (indexPath.row ==1){
        cell.textLabel.text = @"CLEAR WALLET";
    }else{
        cell.textLabel.text = @"EXPORT WALLET";
    }
    cell.textLabel.textColor = BLUELB;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ALLASSET_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (indexPath.row == 2){
        [self toExportWallet];
    }
}
-(void)toExportWallet{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No Wallet"];
        return;
    }
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
