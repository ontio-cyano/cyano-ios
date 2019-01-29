//
//  NewPasswordSheet.m
//  ONTO
//
//  Created by Apple on 2018/9/11.
//  Copyright © 2018年 Zeus. All rights reserved.
//

#import "PasswordSheet.h"
#import "LKLPayCodeTextField.h"
#import "BrowserView.h"
#import "Common.h"
//#import "COTAlertV.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SPACE 10

//屏幕宽高
#define SYSHeight [UIScreen mainScreen].bounds.size.height
#define SYSWidth  [UIScreen mainScreen].bounds.size.width
#define SCALE_W  ([[UIScreen mainScreen] bounds].size.width/375)
#define SafeAreaTopHeight (kScreenHeight == 812.0 ? 88 : 64)
#define StatusBarHeight (kScreenHeight == 812.0 ? 44 : 20)
#define SafeBottomHeight (kScreenHeight == 812.0 ? 34 : 0)
#define PhotoTopHeight  (kScreenHeight == 812.0 ? 64 : 0)

@interface PasswordSheet()
@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UIView    *maskView;
@property (nonatomic, strong) UIWindow  *window;
@property (nonatomic, strong) LKLPayCodeTextField * textF;
@property (nonatomic, copy)   NSString  *title;
@property (nonatomic, strong) BrowserView      *browserView;
@property (nonatomic, copy)   NSString * pwdString;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, assign) BOOL isCheckPWD;
@property (nonatomic, assign) BOOL isCheckLogin;
@property (nonatomic, strong) NSDictionary      *sDic;
@property (nonatomic, copy)   NSString  *actionString;
@property (nonatomic, strong) NSArray   *message;
@end

@implementation PasswordSheet

-(instancetype)initWithTitle:(NSString *)title selectedDic:(NSDictionary*)selectedDic action:(NSString*)action message:(NSArray*)message{
    self = [super init];
    if (self) {
        self.title =title;
        self.pwdString = @"";
        self.isCheckPWD = NO;
        self.isCheckLogin = NO;
        self.sDic = selectedDic;
        self.actionString = action;
        self.message = message;
        [self configUI];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}
-(void)configUI{
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.browserView];
    [self addSubview:self.maskView];
    UIView *v =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, SYSHeight -332*SCALE_W)];
    UITapGestureRecognizer
    *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissScreenBgView)];
    tapGesture.cancelsTouchesInView = YES;
    [v addGestureRecognizer:tapGesture];
    [self addSubview:v];
    [self addSubview:self.bgView];
    [self createDetailView];
}
-(void)createDetailView{
    UILabel* titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 25*SCALE_W, SYSWidth, 23*SCALE_W)];
    titleLB.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLB.text = self.title;
    [titleLB changeSpace:0 wordSpace:1*SCALE_W];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLB];
    
    UIButton* confirmBtn =[[UIButton alloc]initWithFrame:CGRectMake(58*SCALE_W, 232*SCALE_W, SYSWidth - 116*SCALE_W, 60*SCALE_W)];
    confirmBtn.backgroundColor = [UIColor blackColor];
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [confirmBtn.titleLabel changeSpace:0 wordSpace:3*SCALE_W];
    [_bgView addSubview:confirmBtn];
    
    __weak __typeof(self)weakSelf = self;
    _textF = [[LKLPayCodeTextField alloc]initWithFrame:CGRectMake(20*SCALE_W, 100*SCALE_W, SYSWidth -40*SCALE_W, 50*SCALE_W)];
    _textF.isShowTrueCode = NO;
    _textF.isPSW = YES;
    _textF.finishedBlock = ^(NSString *payCodeString) {
        weakSelf.pwdString = payCodeString;
    };
    [_bgView addSubview:_textF];
    
    [confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ([weakSelf.actionString isEqualToString:@"createOntid"]) {
            [weakSelf loadCreateIdJS];
        }else{
            
            [weakSelf loadJS];
        }
    }];
}
- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
-(UIView*)bgView{
    if (!_bgView) {
        
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, SYSHeight-332*SCALE_W , Screen_Width, 332*SCALE_W+SafeBottomHeight)];
        _bgView.clipsToBounds =YES;
        _bgView.backgroundColor =[UIColor whiteColor];
    }
    return _bgView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}

- (void)show {
//    NSInteger y =  Screen_Width==375 ?Screen_height+43:Screen_height ;
    
//    _bgView.frame = CGRectMake(0, y , Screen_Width - (SCALE_W * 0), 524*SCALE_W);
    
    [UIView animateWithDuration:.2 animations:^{

        self.bgView.frame = CGRectMake(0, SYSHeight-332*SCALE_W -246 -PhotoTopHeight, Screen_Width - (SCALE_W * 0), 332*SCALE_W+SafeBottomHeight);
        self.maskView.alpha = .5;
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y += self.bgView.bounds.size.height  -332*SCALE_W +246 ;
        self.bgView.frame = rect;
        self.maskView.alpha =0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.superview.hidden = YES;
    }];
}

- (void)dismiss1 {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y += self.bgView.bounds.size.height   -332*SCALE_W +246 ;
        self.bgView.frame = rect;
    } completion:^(BOOL finished) {
    }];
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{

    _bgView.frame = CGRectMake(0, SYSHeight-332*SCALE_W -246 -PhotoTopHeight, Screen_Width - (SCALE_W * 0), 332*SCALE_W+SafeBottomHeight);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self dismiss1];
    
}

- (BrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[BrowserView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_browserView setCallbackPrompt:^(NSString *prompt) {
            [weakSelf handlePrompt:prompt];
        }];
        [_browserView setCallbackJSFinish:^{
//            [weakSelf loadJS];
        }];
    }
    return _browserView;
}
- (void)loadJS{
    if ([_pwdString isEqualToString:@""]) {
        return;
    }
    NSDictionary* defaultDic  = self.sDic;
    NSArray *controlsArr= defaultDic[@"controls"];
    NSDictionary* detailDic = controlsArr[0];
    [_hub hideAnimated:YES];
    _hub=[ToastUtil showMessage:@"" toView:nil];
    NSString*  jsStr =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",detailDic[@"key"],_pwdString,detailDic[@"address"],detailDic[@"salt"]];
    
    ONTOLOADJSPRE;
    ONTOLOADJS2;
    ONTOLOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    
}
-(void)loadCreateIdJS{
    if ([_pwdString isEqualToString:@""]) {
        return;
    }
    [_hub hideAnimated:YES];
    _hub=[ToastUtil showMessage:@"" toView:nil];
    NSString*  jsStr =  [NSString stringWithFormat:@"Ont.SDK.decryptEncryptedPrivateKey('%@','%@','%@','%@','decryptEncryptedPrivateKey')",self.sDic[@"key"],[Common transferredMeaning:_pwdString],self.sDic[@"address"],self.sDic[@"salt"]];
    
    ONTOLOADJSPRE;
    ONTOLOADJS2;
    ONTOLOADJS3;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
}
- (void)handlePrompt:(NSString *)prompt{
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([prompt hasPrefix:@"decryptEncryptedPrivateKey"]) {
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            _pwdString = @"";
            [_textF clearKeyCode];
            [Common showToast:@"Password error!"];
            
        }else{
            if ([self.actionString isEqualToString:@"exportOntid"]) {
                NSArray * controls = self.sDic[@"controls"];
                NSDictionary * dic = controls[0];
                NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.exportWifPrivakeKey('%@','%@','%@','%@','exportWifByIdentity')",dic[@"key"],[Common transferredMeaning:_pwdString],dic[@"address"],dic[@"salt"]];
                ONTOLOADJSPRE;
                ONTOLOADJS2;
                ONTOLOADJS3;
                [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            }else if ([self.actionString isEqualToString:@"deleteOntid"]) {
                [_hub hideAnimated:YES];
                [self dismiss];
                if (_callback) {
                    _callback(@"");
                }
            }else if ([self.actionString isEqualToString:@"decryptClaim"]) {
                 [_hub hideAnimated:YES];
                NSArray * controls = self.sDic[@"controls"];
                NSDictionary * dic = controls[0];
                NSString * eciesDecrypt0;
                NSString * eciesDecrypt1;
                NSString * eciesDecrypt2;
                if (self.message.count > 0) {
                    eciesDecrypt0 = self.message[0];
                    eciesDecrypt1 = self.message[1];
                    eciesDecrypt2 = self.message[2];
                }
             
                NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.eciesDecrypt('%@','%@','%@','%@','%@','%@','%@','eciesDecrypt')",dic[@"key"],[Common transferredMeaning:_pwdString],dic[@"address"],dic[@"salt"],eciesDecrypt2,eciesDecrypt1,eciesDecrypt0];
                ONTOLOADJSPRE;
                ONTOLOADJS2;
                ONTOLOADJS3;
                NSMutableString *mutStr = [NSMutableString stringWithString:jsStr];
                
                NSRange range = {0,jsStr.length};
                
                //去掉字符串中的空格
                [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
                
                NSRange range2 = {0,mutStr.length};
                //去掉字符串中的换行符
                [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
                
                NSString * ss = [NSString stringWithFormat:@"%@",mutStr];
                [self.browserView.wkWebView evaluateJavaScript:ss completionHandler:nil];
            }else if ([self.actionString isEqualToString:@"createOntid"]){
                NSString* jsStr  =  [NSString stringWithFormat:@"Ont.SDK.exportWifPrivakeKey('%@','%@','%@','%@','exportWifPrivakeKey')",self.sDic[@"key"],[Common transferredMeaning:_pwdString],self.sDic[@"address"],self.sDic[@"salt"]];
                
                ONTOLOADJSPRE;
                ONTOLOADJS2;
                ONTOLOADJS3;
                [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
            }
        }
    }else if ([prompt hasPrefix:@"exportWifByIdentity"]) {
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [self dismiss];
            NSDictionary *resultDic = obj[@"result"];
            if (_callback) {
                _callback(resultDic[@"wif"]);
            }
        }
    }else if ([prompt hasPrefix:@"eciesDecrypt"]) {
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [self dismiss];
            if (_callback) {
                _callback(obj[@"result"]);
            }
        }
    }else if ([prompt hasPrefix:@"exportWifPrivakeKey"] ){
        NSLog(@"exportWifPrivakeKey=%@",obj);
        NSDictionary * result = obj[@"result"];
        NSString *jsStr = [NSString stringWithFormat:@"Ont.SDK.importIdentityWithWifOffChain('%@','%@','%@','importIdentityWithWif')",@"",result[@"wif"],[Common transferredMeaning:self.pwdString]];
        ONTOLOADJSPRE;
        ONTOLOADJS2;
        ONTOLOADJS3;
        [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    }else if ([prompt hasPrefix:@"importIdentityWithWif"] ){
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            NSMutableString *str=[obj valueForKey:@"result"];
            NSDictionary *dict = [Common dictionaryWithJsonString:[str stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"ontid"] forKey:DEFAULTONTID];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:DEFAULTIDENTITY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString * exportAccountToQrcode1 = [NSString stringWithFormat:@"Ont.SDK.exportIdentityToQrcode('%@','exportAccountToQrcode')",[Common dictionaryToJson:dict]];
            [self.browserView.wkWebView evaluateJavaScript:[exportAccountToQrcode1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] completionHandler:nil];
        }
    }else if ([prompt hasPrefix:@"exportAccountToQrcode"] ){
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:DEFAULTACCOUTNKEYSTORE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismiss];
            if (_callback) {
                _callback(obj[@"result"]);
            }
        }
    }
   
    
}

#pragma mark - 消失视图
-(void)dismissScreenBgView{
    [_textF.textField resignFirstResponder];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.3];
    
}

@end
