//
//  ScanViewController.m
//  cyano
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018 LR. All rights reserved.
//

#import "ScanViewController.h"
#import "SGQRCode.h"
#import "BackView.h"
#import <Photos/Photos.h>
#import "OntoPayLoginViewController.h"
#import "PaySureViewController.h"
@interface ScanViewController ()
<SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, copy) NSString *thirdOntId;
@property (nonatomic, copy) NSString *session;
@property (nonatomic, strong) BrowserView *browserView;
@property (nonatomic, copy) NSString *hashString;
@property (nonatomic, copy) NSString *payAddress;
@property (nonatomic, strong)NSMutableArray * walletArray;
@property (nonatomic, strong)NSDictionary * defaultDic;
@property (nonatomic, strong)NSDictionary * payinfoDic;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You do not have camera rights turned on, please turn on in system settings" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    [self createNav];
    [self setupQRCodeScanning];
    [self.view addSubview:self.scanningView];
    [self configScanningView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.scanningView removeTimer];
    [_manager stopRunning];
    [_manager cancelSampleBufferDelegate];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You do not have camera rights turned on, please turn on in system settings" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
}
- (void)configScanningView {
    BackView *backV = [[BackView alloc] initWithFrame:CGRectZero];
    if (self.isCOT) {
        backV.isCOT =self.isCOT;
    }
    [backV setCallbackBack:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.scanningView addSubview:backV];
    
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scanningView).offset(20);
        make.top.equalTo(self.scanningView).offset(StatusBarHeight+3);
        make.height.mas_equalTo(@30);
    }];
    [backV layoutIfNeeded];
    
   
    UIView * whiteBG =[[UIView alloc]init];
    whiteBG.backgroundColor = [UIColor whiteColor];
    [self.scanningView addSubview:whiteBG];
    [whiteBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scanningView);
        make.top.equalTo(self.scanningView).offset(72*SCALE_W+SafeAreaTopHeight);
        make.height.mas_offset(50*SCALE_W);
        make.width.mas_offset(260*SCALE_W);
    }];
    
    UIView *dot =[[UIView alloc]init];
    dot.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [whiteBG addSubview:dot];
    [dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteBG.mas_centerY);
        make.right.equalTo(whiteBG.mas_right).offset(-19.5*SCALE_W);
        make.width.height.mas_offset(10*SCALE_W);
    }];
    //
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"scan";

    [whiteBG addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font =[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor blackColor]; //[UIColor colorWithHexString:@"35BFDF"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.mas_equalTo(self.scanningView);
        make.top.equalTo(whiteBG);
        make.left.equalTo(whiteBG.mas_left).offset(19);
        make.size.mas_equalTo(CGSizeMake(241*SCALE_W, 50*SCALE_W));
    }];
    
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    }
    return _scanningView;
}
#pragma mark SGQRCodeScanManagerDelegate
//扫描回调
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSString * callbackString = [NSString stringWithFormat:@"%@",[metadataObjects[0] valueForKey:@"stringValue"]];
    NSDictionary * dic = [Common dictionaryWithJsonString:callbackString];
    NSLog(@"paydic=%@",dic);
    self.payinfoDic = dic;
    self.walletArray = [NSMutableArray array];
    if ([dic isKindOfClass:[NSDictionary class]] && dic[@"action"]) {
        NSArray * arr = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
        if (arr.count == 0 || arr == nil) {
            [Common showToast:Localized(@"NoWallet")];
            return;
        }else{
            for (NSDictionary *  subDic in arr) {
                if (subDic[@"label"] != nil) {
                    [self.walletArray addObject:subDic];
                }
            }
            if (self.walletArray.count == 0) {
                [Common showToast:Localized(@"NoWallet")];
                return;
            }
        }
        if ([dic[@"action"] isEqualToString:@"login"]) {
            OntoPayLoginViewController * vc =[[OntoPayLoginViewController alloc]init];
            vc.walletArr = self.walletArray;
            vc.payInfo = dic;
            [self.navigationController pushViewController:vc animated:YES];
            [_manager stopRunning];
            return;
        }else if ([dic[@"action"] isEqualToString:@"invoke"]) {
            [_manager stopRunning];
            NSString *jsonStr = [Common getEncryptedContent:ASSET_ACCOUNT];
            NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
            
            PaySureViewController * payVc = [[PaySureViewController alloc]init];
            payVc.payinfoDic = dic;
            payVc.defaultDic = dict;
            payVc.dataArray = self.walletArray;
            [self.navigationController pushViewController:payVc animated:YES];
            return;
            return;
        }
    }
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}
- (void)createNav{
    self.view.backgroundColor = WHITE;
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:@""];
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
