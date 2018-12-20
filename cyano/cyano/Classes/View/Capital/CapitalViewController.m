//
//  CapitalViewController.m
//  Cyano Wallet
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "CapitalViewController.h"
#import "CreateWalletViewController.h"
#import "ScanViewController.h"
@interface CapitalViewController ()
@property(nonatomic,strong)UIView  * bgView;
@property(nonatomic,strong)UIView  * walletView;
@property(nonatomic,strong)UILabel * addressLB;
@property(nonatomic,strong)UILabel * ontNumLB;
@property(nonatomic,strong)UILabel * ongNumLB;
@property(nonatomic,strong)UILabel * claimNumLB;
@property(nonatomic,strong)NSDictionary * walletDict;
@property(nonatomic,weak)NSTimer   * refreshWalletTimer;
@end

@implementation CapitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self createNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
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
        NSLog(@"---***%@",responseObject);
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
            }
        }
        
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
    NSLog(@"222");
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
    _claimNumLB.font = [UIFont systemFontOfSize:14];
    _claimNumLB.textAlignment = NSTextAlignmentCenter;
    [_walletView addSubview:_claimNumLB];
    
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
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletView).offset(40*SCALE_W);
        make.width.mas_offset(120*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.bottom.equalTo(self.walletView).offset(-100*SCALE_W);
    }];
    
    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sendButton.mas_right).offset(5*SCALE_W);
        make.width.mas_offset(120*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
        make.bottom.equalTo(self.walletView).offset(-100*SCALE_W);
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
    nameLB.text =@"Cyano Wallet";
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
- (void)createNav{
//    [self setNavTitle:@"资产"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"smallLogo"] Title:@"返回"];
    [self setNavRightImageIcon:[UIImage imageNamed:@"setting"] Title:@""];
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
