//
//  CapitalViewController.m
//  cyano
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "CapitalViewController.h"
#import "CreateWalletViewController.h"
#import "ScanViewController.h"
#import "ReceiveViewController.h"
#import "SendViewController.h"
#import "ImportWalletViewController.h"
#import "WebIdentityViewController.h"
#import "SendConfirmView.h"
#import "TokensCell.h"
#import "Oep4TokensViewController.h"
@interface CapitalViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView  * bgView;
@property(nonatomic,strong)UIView  * walletView;
@property(nonatomic,strong)UILabel * addressLB;
@property(nonatomic,strong)UILabel * ontNumLB;
@property(nonatomic,strong)UILabel * ongNumLB;
@property(nonatomic,strong)UILabel * claimNumLB;
@property(nonatomic,strong)NSDictionary * walletDict;
@property(nonatomic,weak)NSTimer   * refreshWalletTimer;
@property(nonatomic,copy)NSString  *claimOngAmount;
@property(nonatomic,copy)NSString  *ongAmount;
@property(nonatomic,copy)NSString  *password;
@property(nonatomic,strong)BrowserView     *browserView;
@property(nonatomic,strong)SendConfirmView *sendConfirmV;
@property(nonatomic,strong)MBProgressHUD   *hub;
@property(nonatomic,strong)UITableView     *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@end

@implementation CapitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self.view addSubview:self.browserView];
    [self createNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getOep4];
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT]; //[Common getEncryptedContent:ASSET_ACCOUNT];
    if (jsonStr) {
        _bgView.hidden = YES;
        _walletView.hidden = NO;
        [self getData];
    }else{
        _bgView.hidden = NO;
        _walletView.hidden = YES;
    }
    [self toRefreshWallet];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.refreshWalletTimer invalidate];
    self.refreshWalletTimer = nil;
}
- (void)createUI{
    [self createEmptyWalletV];
    [self createWalletView];
}
- (void)getData{
    [self getAmount];
    
}
-(void)getAmount{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    self.walletDict = dict;
    if (dict.count == 0) {
        return;
    }
    NSString *urlStr;
    if ([dict isKindOfClass:[NSDictionary class]] && dict[@"label"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"address"]];
    } else {
        urlStr = [NSString stringWithFormat:@"%@/%@", Get_Blance, dict[@"sharedWalletAddress"]];
    }
    CCSuccess successCallback = ^(id responseObject, id responseOriginal) {
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            return;
        }
        for (NSDictionary *dic in (NSArray *) responseObject) {
            if ([dic[@"AssetName"] isEqualToString:@"ont"]) {
                self.ontNumLB.text = [NSString stringWithFormat:@"%@",dic[@"Balance"]];
            }
            if ([dic[@"AssetName"] isEqualToString:@"ong"]) {
                NSString * ongString = [NSString stringWithFormat:@"%@",dic[@"Balance"]];
                self.ongNumLB.text = [Common getPrecision9Str:ongString];
                if ([self.ongNumLB.text isEqualToString:@"0"]) {
                    self.ongNumLB.text = ONG_ZERO;
                }
            }
            if ([dic[@"AssetName"] isEqualToString:@"unboundong"]) {
                self.claimNumLB.text = [NSString stringWithFormat:@"%@(Claim)",dic[@"Balance"]];
                self.claimOngAmount = dic[@"Balance"];
            }
        }
        
    };
    CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [Common showToast:@"Network error"];
        self.ontNumLB.text = @"0";
        self.ongNumLB.text = @"0";
        self.claimNumLB.text = @"0(Claim)";
    };
    
    [[CCRequest shareInstance] requestWithURLString1:urlStr
                                          MethodType:MethodTypeGET
                                              Params:nil
                                             Success:successCallback
                                             Failure:failureCallback];
}
-(void)getOep4{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%d/%d", OEP4Info, @"oep4",20,1];
    CCSuccess successCallback = ^(id responseObject, id responseOriginal) {
        if ([[responseOriginal valueForKey:@"error"] integerValue] > 0) {
            return;
        }
        self.dataArray = [NSMutableArray array];
        NSDictionary * ResultDic = responseOriginal[@"Result"];
        if (ResultDic.count>0) {
            NSArray * ContractList = ResultDic[@"ContractList"];
            if (ContractList.count>0) {
                for (NSDictionary * dic in ContractList) {
                    [self.dataArray addObject:dic];
                }
            }
        }
        
        [self.tableView reloadData];
    };
    CCFailure failureCallback = ^(NSError *error, NSString *errorDesc, id responseOriginal) {
        [Common showToast:@"Network error"];
    };
    
    [[CCRequest shareInstance] requestWithURLString1:urlStr
                                          MethodType:MethodTypeGET
                                              Params:nil
                                             Success:successCallback
                                             Failure:failureCallback];
}
-(void)navRightAction{
    ScanViewController * vc = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createWalletView{
    _walletView = [[UIView alloc]init];
    _walletView.hidden = NO;
    _walletView.backgroundColor = TABLEBACKCOLOR;
    [self.view addSubview:_walletView];
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = BLUELB;
    [_walletView addSubview:topView];
    
    _addressLB = [[UILabel alloc]init];
    _addressLB.textColor = WHITE;
    _addressLB.numberOfLines = 0;
    _addressLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _addressLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:_addressLB];
    
    UILabel * ontLB = [[UILabel alloc]init];
    ontLB.text = @"ONT";
    ontLB.textColor = WHITE;
    ontLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    ontLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:ontLB];
    
    UILabel * ongLB = [[UILabel alloc]init];
    ongLB.text = @"ONG";
    ongLB.textColor = WHITE;
    ongLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    ongLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:ongLB];
    
    _ontNumLB = [[UILabel alloc]init];
    _ontNumLB.textColor = WHITE;
    _ontNumLB.numberOfLines = 0;
    _ontNumLB.font = [UIFont systemFontOfSize:18];
    _ontNumLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:_ontNumLB];
    
    _ongNumLB = [[UILabel alloc]init];
    _ongNumLB.textColor = WHITE;
    _ongNumLB.numberOfLines = 0;
    _ongNumLB.font = [UIFont systemFontOfSize:18];
    _ongNumLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:_ongNumLB];
    
    _claimNumLB = [[UILabel alloc]init];
    _claimNumLB.textColor = WHITE;
    _claimNumLB.numberOfLines = 0;
    _claimNumLB.userInteractionEnabled = YES;
    _claimNumLB.font = [UIFont systemFontOfSize:14];
    _claimNumLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:_claimNumLB];
    
    UITapGestureRecognizer
    *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(claimOng)];
    [_claimNumLB addGestureRecognizer:tapGesture];
    
    UIButton * sendButton = [[UIButton alloc]init];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    [sendButton setTitleColor:BLUELB forState:UIControlStateNormal];
    sendButton.backgroundColor = BUTTONBACKCOLOR;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_walletView addSubview:sendButton];
    
    UIButton * receiveButton = [[UIButton alloc]init];
    [receiveButton setTitle:@"RECEIVE" forState:UIControlStateNormal];
    [receiveButton setTitleColor:BLUELB forState:UIControlStateNormal];
    receiveButton.backgroundColor = BUTTONBACKCOLOR;
    receiveButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_walletView addSubview:receiveButton];
    
    UIButton * recordButton = [[UIButton alloc]init];
//    [recordButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [recordButton setTitle:@"RECORD" forState:UIControlStateNormal];
    [recordButton setTitleColor:BLUELB forState:UIControlStateNormal];
    recordButton.backgroundColor = BUTTONBACKCOLOR;
    recordButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_walletView addSubview:recordButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.backgroundColor = TABLEBACKCOLOR;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_walletView addSubview:_tableView];
    
    [sendButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        SendViewController * vc = [[SendViewController alloc]init];
        vc.ongNum = self.ongNumLB.text;
        vc.ontNum = self.ontNumLB.text;
        vc.walletDict = self.walletDict;
        vc.isONT = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [receiveButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        ReceiveViewController * vc = [[ReceiveViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [recordButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString * baseUrl = [[NSUserDefaults standardUserDefaults] valueForKey:RECORDURI];
        NSString * urlString = [NSString stringWithFormat:baseUrl,self.walletDict[@"address"]];
        WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
        VC.introduce = urlString;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    [_walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.walletView);
        make.height.mas_offset(150*SCALE_W);
    }];
    
    [_addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.walletView);
        make.top.equalTo(self.walletView).offset(20*SCALE_W);
    }];
    
    [ontLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletView);
        make.right.equalTo(self.walletView.mas_centerX);
        make.top.equalTo(self.addressLB.mas_bottom).offset(20*SCALE_W);
    }];
    
    [ongLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.walletView);
        make.left.equalTo(self.walletView.mas_centerX);
        make.top.equalTo(self.addressLB.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_ontNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletView);
        make.right.equalTo(self.walletView.mas_centerX);
        make.top.equalTo(ontLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [_ongNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.walletView);
        make.left.equalTo(self.walletView.mas_centerX);
        make.top.equalTo(ongLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    [_claimNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.walletView);
        make.left.equalTo(self.walletView.mas_centerX);
        make.top.equalTo(self.ongNumLB.mas_bottom).offset(10*SCALE_W);
    }];
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom).offset(5);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 34 - 50*SCALE_W - 5);
        }else{
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 50*SCALE_W - 5);
        }
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletView).offset(20*SCALE_W);
        make.width.mas_offset((SYSWidth - 50*SCALE_W)/3);
        make.height.mas_offset(50*SCALE_W);
//        make.top.equalTo(self.table.mas_bottom).offset(5);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 34 - 5 );
        }else{
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 5 );
        }
    }];

    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sendButton.mas_right).offset(5*SCALE_W);
        make.width.mas_offset((SYSWidth - 50*SCALE_W)/3);
        make.height.mas_offset(50*SCALE_W);
//        make.top.equalTo(topView.mas_bottom).offset(5);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 34 - 5);
        }else{
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 5);
        }
    }];

    [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiveButton.mas_right).offset(5*SCALE_W);
        make.width.mas_offset((SYSWidth - 50*SCALE_W)/3);
        make.height.mas_offset(50*SCALE_W);
//        make.top.equalTo(topView.mas_bottom).offset(5);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49 - 34- 5 );
        }else{
            make.bottom.equalTo(self.walletView.mas_bottom).offset(-49- 5 );
        }
    }];
}
- (void)createEmptyWalletV{
    _bgView = [[UIView alloc]init];
    _bgView.hidden = NO;
    [self.view addSubview:_bgView];
    
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"capitalLogo"];
    [_bgView addSubview:logoImage];
    
    UILabel * nameLB = [[UILabel alloc]init];
    nameLB.textColor = [UIColor whiteColor];
    nameLB.text =@"cyano";
    nameLB.textAlignment = NSTextAlignmentCenter;
    nameLB.font = [UIFont systemFontOfSize:28];
    [nameLB changeSpace:0 wordSpace:1];
    [_bgView addSubview:nameLB];
    
    UILabel * alertLB = [[UILabel alloc]init];
    alertLB.textColor = [UIColor whiteColor];
    alertLB.numberOfLines = 0;
    alertLB.text = @"To start using Ontology\ncreate a new account or import an existing one.";
    alertLB.font = [UIFont systemFontOfSize:16];
    [alertLB changeSpace:2 wordSpace:0];
    alertLB.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:alertLB];
    
    UIButton * createButton = [[UIButton alloc]init];
    createButton.backgroundColor = BUTTONBACKCOLOR;
    [createButton setTitle:@"NEW ACCOUNT" forState:UIControlStateNormal];
    [createButton setTitleColor:BLUELB forState:UIControlStateNormal];
    createButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_bgView addSubview:createButton];
    
    UIButton * importButton = [[UIButton alloc]init];
    importButton.backgroundColor = BUTTONBACKCOLOR;
    [importButton setTitle:@"IMPORT ACCOUNT" forState:UIControlStateNormal];
    [importButton setTitleColor:BLUELB forState:UIControlStateNormal];
    importButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_bgView addSubview:importButton];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [createButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        CreateWalletViewController * vc = [[CreateWalletViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [importButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        ImportWalletViewController * vc = [[ImportWalletViewController alloc]init];
        vc.isWIF = YES;
        [self.navigationController pushViewController: vc animated:YES];
    }];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20*SCALE_W);
        make.width.mas_offset(153*SCALE_W);
        make.height.mas_offset(112*SCALE_W);
    }];
    
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(logoImage.mas_bottom).offset(20*SCALE_W);
    }];
    
    [alertLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(nameLB.mas_bottom).offset(20*SCALE_W);
    }];
    
    [createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(alertLB.mas_bottom).offset(20*SCALE_W);
        make.width.mas_offset(200*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
    }];
    
    [importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(createButton.mas_bottom).offset(10*SCALE_W);
        make.width.mas_offset(200*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headV = [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel * tokensLB = [[UILabel alloc]init];
    tokensLB.text = @"OEP-4 tokens";
    tokensLB.textAlignment = NSTextAlignmentLeft;
    [headV addSubview:tokensLB];
    
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(SYSWidth);
        make.height.mas_offset(50);
    }];
    
    [tokensLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headV).offset(20);
        make.centerY.equalTo(headV);
    }];
    return headV;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    TokensCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TokensCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell reloadCellByDic:dic];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    Oep4TokensViewController *vc =[[Oep4TokensViewController alloc]init];
    vc.ongNum = self.ongNumLB.text;
    vc.ontNum = self.ontNumLB.text;
    vc.walletDict = self.walletDict;
    vc.isONT = YES;
    vc.isOEP4 = YES;
    vc.tokenDict = dic;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -  刷新钱包定时器
- (void)toRefreshWallet
{
    if (!self.refreshWalletTimer){
        //如果计时器为空就创建计时器
        self.refreshWalletTimer =[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getData) userInfo:nil repeats:YES];
        [self.refreshWalletTimer fire];
    }else{
        //如果计时器不为空，就销毁上一个计时器，然后再创建新的计时器（计时器创建了就一定要销毁）
        [self.refreshWalletTimer invalidate];
        self.refreshWalletTimer = nil;
        
        //调用自身方法创建计时器
        [self toRefreshWallet];
    }
    
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
            weakSelf.password = password;
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
    NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",dict[@"key"],[Common transferredMeaning:self.password],dict[@"address"],dict[@"salt"]];
    
    if (self.password.length==0) {
        return;
    }
    _hub=[ToastUtil showMessage:@"" toView:nil];
    [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
        [weakSelf handlePrompt:prompt];
    }];
    
}

-(void)claimOng{
    self.sendConfirmV.paybyStr = @"";
    self.sendConfirmV.amountStr = @"";
    self.sendConfirmV.isWalletBack = YES;
    [self.sendConfirmV show];
}
- (void)handlePrompt:(NSString *)prompt{
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            self.password  = @"";
            [Common showToast:@"Password error"];
        }else{
            [self.sendConfirmV dismiss];
            [self toClaimOng];
        }
    }else if ([prompt hasPrefix:@"claimOng"]){
        NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.sendTransaction('%@','sendTransaction')",obj[@"tx"]];
        
        LOADJS1;
        LOADJS2;
        LOADJS3;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    }else if ([prompt hasPrefix:@"sendTransaction"]){
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] == 0) {
            [Common showToast:@"The transaction has been issued."];
        }else{
            if ([[obj valueForKey:@"error"] integerValue] > 0) {
                [Common showToast:[NSString stringWithFormat:@"%@:%@",@"System error",[obj valueForKey:@"error"]]];
            }
        }
    }
    
}
-(void)toClaimOng{
    NSString * fee = [Common getRealFee:@"500" GasLimit:@"20000"];
    BOOL isEnough = [Common isEnoughOng:self.ongNumLB.text fee:fee];
    if (isEnough) {
        // 提取claimable的ONG
        NSDecimalNumber *decimalONG = [[NSDecimalNumber alloc] initWithString:self.claimOngAmount];
        NSString * claimONG10_9str = [Common getONGMul10_9Str:decimalONG.stringValue];
        NSString * claimOngUrlStr =
        [NSString stringWithFormat:@"Ont.SDK.claimOng('%@','%@','%@','%@','%@','%@','%@','%@','claimOng')",
         self.walletDict[@"address"],
         claimONG10_9str,
         self.walletDict[@"key"],
         [Common transferredMeaning:self.password],
         self.walletDict[@"salt"],
         @"500",
         @"20000",
         self.walletDict[@"address"]];
        [APP_DELEGATE.browserView.wkWebView evaluateJavaScript:claimOngUrlStr completionHandler:nil];
                __weak typeof(self) weakSelf = self;
        [APP_DELEGATE.browserView setCallbackPrompt:^(NSString *prompt) {
                [weakSelf handlePrompt:prompt];
        }];
    }else{
        [Common showToast:@"Not enough ONG to make the transaction."];
    }
}
- (void)createNav{
//    [self setNavTitle:@"资产"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"smallLogo"] Title:@"返回"];
    [self setNavRightImageIcon:[UIImage imageNamed:@"coticon-none"] Title:@""];
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
