//
//  ONTIdViewController.m
//  cyano
//
//  Created by Apple on 2019/1/15.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTIdViewController.h"
#import "DAppViewController.h"
#import "BrowserView.h"
#import <Masonry.h>
#import "ONTOSDKViewController.h"
@interface ONTIdViewController ()
<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UITextField  * pswField;
@property(nonatomic,strong)UITextField  * pswConfirmField;
@property(nonatomic,strong)UIButton     * sureBtn;
@property(nonatomic,strong)UITextView   * textview;
@property(nonatomic,strong)UIButton     * confirmBtn;
@property(nonatomic,strong)UIView       * alertView;
@property(nonatomic, strong) BrowserView *browserView;
@property(nonatomic,strong)MBProgressHUD *hub;

@end

@implementation ONTIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self createNav];
    [self createUI];
}
-(void)createUI{
    [self.view addSubview:self.browserView];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.pagingEnabled = NO;
    _scrollView.canCancelContentTouches = YES;
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer
    *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAlert)];
    tapGesture.cancelsTouchesInView = YES;
    [_scrollView addGestureRecognizer:tapGesture];
    
    UIImageView * topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"ONTOLogo" inBundle:ONTOBundle compatibleWithTraitCollection:nil];
    [_scrollView addSubview:topImage];
    
    UILabel * OntPsw = [[UILabel alloc]init];
    OntPsw.text = @"ONT ID Password";
    [OntPsw changeSpace:0 wordSpace:1];
    OntPsw.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [_scrollView addSubview:OntPsw];
    
    UIButton * pswInfoBtn = [[UIButton alloc]init];
    [pswInfoBtn setImage:[UIImage imageNamed:@"ONTOBlueInfo" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [pswInfoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:pswInfoBtn];
    
    _pswField = [[UITextField alloc]init];
    _pswField.placeholder = @"6 digits";
    _pswField.secureTextEntry = YES;
    _pswField.keyboardType = UIKeyboardTypeNumberPad;
    _pswField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _pswField.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    [_pswField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_scrollView addSubview:_pswField];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [_scrollView addSubview:line];
    
    UIButton * showPswBtn = [[UIButton alloc]init];
    [showPswBtn setImage:[UIImage imageNamed:@"ONTOEyeclose" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [showPswBtn setImage:[UIImage imageNamed:@"ONTOEyeopen" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    showPswBtn.selected = NO;
    [showPswBtn addTarget:self action:@selector(showPSW:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:showPswBtn];
    
    UILabel * OntConfirmPsw = [[UILabel alloc]init];
    OntConfirmPsw.text = @"Confirm Password";
    [OntConfirmPsw changeSpace:0 wordSpace:1];
    OntConfirmPsw.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [_scrollView addSubview:OntConfirmPsw];
    
    _pswConfirmField = [[UITextField alloc]init];
    _pswConfirmField.placeholder = @"Re-enter password";
    _pswConfirmField.secureTextEntry = YES;
    _pswConfirmField.keyboardType = UIKeyboardTypeNumberPad;
    _pswConfirmField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [_pswConfirmField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _pswConfirmField.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    [_scrollView addSubview:_pswConfirmField];
    
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [_scrollView addSubview:line1];
    
    _sureBtn = [[UIButton alloc]init];
    [_sureBtn setImage:[UIImage imageNamed:@"ONTOunselect" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_sureBtn setImage:[UIImage imageNamed:@"ONTOSelected" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    _sureBtn.selected = NO;
    [_sureBtn addTarget:self action:@selector(agreeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sureBtn];
    
    _textview = [[UITextView alloc] init];
    [self protocolIsSelect:NO];
    [_scrollView addSubview:_textview];
    
    _confirmBtn = [[UIButton alloc]init];
    [_confirmBtn setTitle:@"VERIFY YOUR IDENTITY" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    _confirmBtn.layer.cornerRadius = 0.5;
    [_confirmBtn.titleLabel changeSpace:0 wordSpace:0.5];
    _confirmBtn.selected = NO;
    _confirmBtn.userInteractionEnabled = NO;
    [_confirmBtn addTarget:self action:@selector(createOntId) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_confirmBtn];
    
    UIButton * alertBtn = [[UIButton alloc]init];
    [alertBtn setImage:[UIImage imageNamed:@"ONTOBlackInfo" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [alertBtn setTitle:@"You cannot create the ONT ID until you have completed authentication." forState:UIControlStateNormal];
    [alertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    alertBtn.titleEdgeInsets = UIEdgeInsetsMake(alertBtn.frame.size.height-alertBtn.imageView.frame.size.height-alertBtn.imageView.frame.origin.y, -alertBtn.imageView.frame.size.width +10, 0, 0);
    alertBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    alertBtn.titleLabel.numberOfLines = 0;
    [_scrollView addSubview:alertBtn];
    
    _alertView = [[UIView alloc]init];
    _alertView.layer.cornerRadius = 3;
    _alertView.backgroundColor = [UIColor blackColor];
    _alertView.hidden = YES;
    [_scrollView addSubview:_alertView];
    
    UILabel * alertInfo = [[UILabel alloc]init];
    alertInfo.textColor = [UIColor whiteColor];
    alertInfo.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    alertInfo.numberOfLines = 0;
    alertInfo.text = @"ONT ID password is used to protect your identity information.\nONTO does not save your password, nor help you recover your passord.\nPlease remember it carefully";
    [_alertView addSubview:alertInfo];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        if (ONTOIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
    
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.scrollView).offset(30);
        make.width.height.mas_offset(100);
    }];
    
    [OntPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(topImage.mas_bottom).offset(52);
    }];
    
    [pswInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(OntPsw);
        make.left.equalTo(OntPsw.mas_right).offset(7);
        make.width.height.mas_offset(17);
    }];
    
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pswInfoBtn);
        make.top.equalTo(pswInfoBtn.mas_bottom).offset(10);
        make.width.mas_offset(168);
    }];
    
    [alertInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.alertView).offset(10);
        make.right.bottom.equalTo(self.alertView).offset(-10);
    }];
    
    [_pswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(OntPsw.mas_bottom).offset(14);
        make.height.mas_offset(25);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.pswField.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    [showPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.pswField);
    }];
    
    [OntConfirmPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    
    [_pswConfirmField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(OntConfirmPsw.mas_bottom).offset(14);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.pswConfirmField.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.top.equalTo(line1.mas_bottom).offset(25);
        make.height.mas_offset(22);
        make.width.mas_offset(28.5);
    }];
    
    [_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sureBtn.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.sureBtn).offset(-5);
    }];
    
    [self.view layoutIfNeeded];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ONTOIsiPhone5) {
            make.left.equalTo(self.view).offset(48);
            make.right.equalTo(self.view).offset(-48);
        }else{
            make.left.equalTo(self.view).offset(58);
            make.right.equalTo(self.view).offset(-58);
        }
        make.height.mas_offset(60);
        if (ONTOIsiPhone5) {
            make.top.equalTo(self.sureBtn.mas_bottom).offset(143);
        } else if (ONTOIsiPhoneX) {
            CGFloat h = ONTOHeight - self.sureBtn.origin.y - 22 - 88 - 34 - 100;
            make.top.equalTo(self.sureBtn.mas_bottom).offset(h);
        }else{
            CGFloat h = ONTOHeight - self.sureBtn.origin.y - 22 - 64 -100;
            make.top.equalTo(self.sureBtn.mas_bottom).offset(h);
        }
        
        make.bottom.equalTo(self.scrollView).offset(-40);
        
    }];
    
    [alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(70);
        make.right.equalTo(self.view).offset(-70);
        make.bottom.equalTo(self.confirmBtn.mas_top).offset(-30);
    }];
    
}

-(void)showPSW:(UIButton*)btn{
    [self.pswField resignFirstResponder];
    [self.pswConfirmField resignFirstResponder];
    if (!btn.selected) {
        self.pswField.secureTextEntry =NO;
        self.pswConfirmField.secureTextEntry =NO;
    }else{
        self.pswField.secureTextEntry =YES;
        self.pswConfirmField.secureTextEntry =YES;
    }
    btn.selected =!btn.selected;
}
-(void)createNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self setTitle:@"ONT ID"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"ONTOBack" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
}
- (void)protocolIsSelect:(BOOL)select {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"I agreed with Terms of Service and Privacy Policy."];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"Terms://"
                             range:[[attributedString string] rangeOfString:@"Terms of Service"]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"Privacy://"
                             range:[[attributedString string] rangeOfString:@"Privacy Policy"]];
    UIImage *image = select ==  YES? [UIImage imageNamed:@"ONTOSelected" inBundle:ONTOBundle compatibleWithTraitCollection:nil]:[UIImage imageNamed:@"ONTOunselect" inBundle:ONTOBundle compatibleWithTraitCollection:nil];
    CGSize size = CGSizeMake(0, 0);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [image drawInRect:CGRectMake(0, 2, size.width, size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = resizeImage;
    NSMutableAttributedString *imageString = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
    [imageString addAttribute:NSLinkAttributeName
                        value:@"checkbox://"
                        range:NSMakeRange(0, imageString.length)];
    [attributedString insertAttributedString:imageString atIndex:0];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2; // 调整行间距
    NSRange range = NSMakeRange(0, imageString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    //    _textview.textColor = [UIColor colorWithHexString:@"#6A797C"];
    _textview.attributedText = attributedString;
    _textview.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#196BD8"],
                                     NSUnderlineColorAttributeName: [UIColor colorWithHexString:@"#AAB3B4"],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    _textview.delegate = self;
    _textview.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _textview.scrollEnabled = NO;
  
}
-(void)showInfo{
    self.alertView.hidden =NO;
    [_pswField resignFirstResponder];
    [_pswConfirmField resignFirstResponder];
}
-(void)agreeBtn{
    _sureBtn.selected = !_sureBtn.selected;
    if (_sureBtn.selected && _pswField.text.length>0 && _pswConfirmField.text.length>0) {
        _confirmBtn.backgroundColor = [UIColor blackColor];
        _confirmBtn.userInteractionEnabled = YES;
    }else{
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
        _confirmBtn.userInteractionEnabled = NO;
    }

}
-(void)createOntId{
    if (self.pswField.text.length < 6||self.pswConfirmField.text.length < 6 ) {
        
        [Common showToast:@"6 digits"];
        return;
    }
    if (!_sureBtn.selected) {
        [Common showToast:@"Please check box"];
        return;
    }
    if ([self.pswConfirmField.text isEqualToString:self.pswField.text]) {
        [self toCreateONTId];
    }else{
        [Common showToast:@"The passwords do not match"];
    }
}
-(void)toCreateONTId{
    _hub=[ToastUtil showMessage:@"" toView:nil];
    NSString * jsStr = jsStr = [NSString stringWithFormat:@"Ont.SDK.createIdentity('%@','%@','%@','%@','%@','createIdentity')",
                                @"",
                                self.pswField.text,
                                @"ATGJSGzm2poCB8N44BgrAccJcZ64MFf187",
                                @"500",
                                @"20000"];
    ONTOLOADJSPRE;
    ONTOLOADJS2;
    ONTOLOADJS3;
    __weak typeof(self) weakSelf = self;
    [self.browserView.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    [self.browserView setCallbackPrompt:^(NSString * prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
- (void)handlePrompt:(NSString *)prompt{
    
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // 密码解密回调处理
    
    if ([prompt hasPrefix:@"createIdentity"]) {
        
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            [_hub hideAnimated:YES];
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
            return;
        }else{
            NSString * ontIdTxString = [obj valueForKey:@"tx"];
            NSMutableString *str=[obj valueForKey:@"result"];
            NSDictionary *dict = [Common dictionaryWithJsonString:[str stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:ontIdTxString forKey:ONTIDTX];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"ontid"] forKey:DEFAULTONTID];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:DEFAULTIDENTITY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString * exportAccountToQrcode1 = [NSString stringWithFormat:@"Ont.SDK.exportIdentityToQrcode('%@','exportAccountToQrcode')",[Common dictionaryToJson:dict]];
            [self.browserView.wkWebView evaluateJavaScript:[exportAccountToQrcode1 stringByReplacingOccurrencesOfString:@"\n" withString:@""] completionHandler:nil];
        }
        
    }else if ([prompt hasPrefix:@"exportAccountToQrcode"]){
        [_hub hideAnimated:YES];
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:DEFAULTACCOUTNKEYSTORE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        // TODO
        ONTOSDKViewController * vc= [[ONTOSDKViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)textFieldDidChange:(UITextField *)textField{
    if (_sureBtn.selected && _pswField.text.length>0 && _pswConfirmField.text.length>0) {
        _confirmBtn.backgroundColor = [UIColor blackColor];
        _confirmBtn.userInteractionEnabled = YES;
    }else{
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
        _confirmBtn.userInteractionEnabled = NO;
    }
    if (textField.text.length > 6) {
        
        textField.text = [textField.text substringToIndex:6];
        
    }
    
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL scheme] isEqualToString:@"Terms"]) {
        DAppViewController * vc = [[DAppViewController alloc]init];
        vc.dappUrl = @"https://onto.app/terms";
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"Privacy"]) {
        DAppViewController * vc = [[DAppViewController alloc]init];
        vc.dappUrl = @"https://onto.app/privacy";
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.alertView.hidden =YES;
}
-(void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.alertView.hidden =YES;
}
-(void)hiddenAlert{
    self.alertView.hidden =YES;
    [_pswField resignFirstResponder];
    [_pswConfirmField resignFirstResponder];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
