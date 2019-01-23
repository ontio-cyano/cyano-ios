//
//  ONTIdImportViewController.m
//  cyano
//
//  Created by Apple on 2019/1/21.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTIdImportViewController.h"
#import "UITextView+Placeholder.h"
#import "BrowserView.h"
#import "DAppViewController.h"
@interface ONTIdImportViewController ()
<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UITextView  * textView;
@property(nonatomic,strong)UITextField * pswField;
@property(nonatomic,strong)UITextField * pswConfirmField;
@property(nonatomic,strong)UITextView  * infotextview;
@property(nonatomic,strong)UIButton    * sureBtn;
@property(nonatomic,strong)UIButton    * importBtn;
@property(nonatomic,strong)MBProgressHUD *hub;
@property(nonatomic, strong) BrowserView *browserView;
@end

@implementation ONTIdImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    UILabel * topLB = [[UILabel alloc]init];
    topLB.text = @"ONT ID Private Key (WIF format) Import";
    topLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [topLB changeSpace:0 wordSpace:0.5];
    [_scrollView addSubview:topLB];
    
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _textView.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    _textView.placeholderLabel.text = @"Please paste your Private Key (WIF format) here.";
    [_scrollView addSubview:_textView];
    
    UIButton * whatBtn = [[UIButton alloc]init];
    [whatBtn setImage:[UIImage imageNamed:@"ONTOBlueInfo" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [whatBtn setTitle:@"What is Private Key (WIF format)?" forState:UIControlStateNormal];
    [whatBtn setTitleColor:[UIColor colorWithHexString:@"#196BD8"] forState:UIControlStateNormal];
    whatBtn.titleEdgeInsets = UIEdgeInsetsMake(whatBtn.frame.size.height-whatBtn.imageView.frame.size.height-whatBtn.imageView.frame.origin.y, -whatBtn.imageView.frame.size.width +10, 0, 0);
    whatBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    whatBtn.titleLabel.numberOfLines = 0;
    [_scrollView addSubview:whatBtn];
    
    UILabel * OntPsw = [[UILabel alloc]init];
    OntPsw.text = @"ONT ID Password";
    [OntPsw changeSpace:0 wordSpace:1];
    OntPsw.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [_scrollView addSubview:OntPsw];
    
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
    _pswConfirmField.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    [_pswConfirmField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_scrollView addSubview:_pswConfirmField];
    
    UIView * line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [_scrollView addSubview:line1];
    
    _sureBtn = [[UIButton alloc]init];
    [_sureBtn setImage:[UIImage imageNamed:@"ONTOunselect" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_sureBtn setImage:[UIImage imageNamed:@"ONTOSelected" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    _sureBtn.selected = NO;
    [_sureBtn addTarget:self action:@selector(agreenBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sureBtn];
    
    _infotextview = [[UITextView alloc] init];
    [self protocolIsSelect:NO];
    [_scrollView addSubview:_infotextview];
    
    _importBtn = [[UIButton alloc]init];
    [_importBtn setTitle:@"IMPORT" forState:UIControlStateNormal];
    [_importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _importBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
    _importBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    _importBtn.layer.cornerRadius = 0.5;
    [_importBtn.titleLabel changeSpace:0 wordSpace:1];
    _importBtn.selected = NO;
    _importBtn.userInteractionEnabled = NO;
    [_importBtn addTarget:self action:@selector(importOntId) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_importBtn];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        if (ONTOIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
    
    [topLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.scrollView).offset(30);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(topLB.mas_bottom).offset(20);
        make.height.mas_offset(160);
    }];
    
    [whatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
    }];
    
    [OntPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(whatBtn.mas_bottom).offset(34);
    }];
    
    [_pswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(OntPsw.mas_bottom).offset(14);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.pswField.mas_bottom).offset(10);
        make.height.mas_offset(1);
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
    }];
    
    [_infotextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sureBtn.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.sureBtn).offset(-5);
    }];
    
    [self.view layoutIfNeeded];
    
    [_importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58);
        make.right.equalTo(self.view).offset(-58);
        make.height.mas_offset(60);
        if (ONTOIsiPhone5) {
            make.top.equalTo(self.sureBtn.mas_bottom).offset(106);
        } else if (ONTOIsiPhoneX) {
            CGFloat h = ONTOHeight - self.sureBtn.origin.y - 22 - 88 - 34 - 100;
            make.top.equalTo(self.sureBtn.mas_bottom).offset(h);
        }else{
            CGFloat h = ONTOHeight - self.sureBtn.origin.y - 22 - 64 -100;
            make.top.equalTo(self.sureBtn.mas_bottom).offset(h);
        }
        
        make.bottom.equalTo(self.scrollView).offset(-40);
    }];
}
-(void)agreenBtnAction{
    _sureBtn.selected = !_sureBtn.selected;
    if (_sureBtn.selected && _pswField.text.length>0 && _pswConfirmField.text.length>0) {
        _importBtn.backgroundColor = [UIColor blackColor];
        _importBtn.userInteractionEnabled = YES;
    }else{
        _importBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
        _importBtn.userInteractionEnabled = NO;
    }
}
-(void)importOntId{
    if (self.pswField.text.length < 6||self.pswConfirmField.text.length < 6 ) {
        
        [Common showToast:@"6 digits"];
        return;
    }
    if (!_sureBtn.selected) {
        [Common showToast:@"Please check box"];
        return;
    }
    if (_textView.text.length !=52) {
        [Common showToast:@"Failed to import ! Please input 52 characters ."];
        return;
    }
    if ([self.pswConfirmField.text isEqualToString:self.pswField.text]) {
        [self toImportONTId];
    }else{
        [Common showToast:@"The passwords do not match"];
    }
}
-(void)toImportONTId{
    NSString *jsurl = [NSString stringWithFormat:@"Ont.SDK.importIdentityWithWif('%@','%@','%@','importIdentityWithWif')",@"",self.textView.text,[Common base64EncodeString:self.pswField.text]];
    _hub=[ToastUtil showMessage:@"" toView:nil];
    ONTOLOADJSPRE;
    ONTOLOADJS2;
    ONTOLOADJS3;
    __weak typeof(self) weakSelf = self;
    [self.browserView.wkWebView evaluateJavaScript:jsurl completionHandler:nil];
    [self.browserView setCallbackPrompt:^(NSString * prompt) {
        [weakSelf handlePrompt:prompt];
    }];
}
// TS SDK 回调处理
- (void)handlePrompt:(NSString *)prompt{
    
    
    NSArray *promptArray = [prompt componentsSeparatedByString:@"params="];
    NSString *resultStr = promptArray[1];
    
    id obj = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    // 密码解密回调处理
    if ([prompt hasPrefix:@"importIdentityWithWif"]) {
        if ([[obj valueForKey:@"error"] integerValue] > 0) {
             [_hub hideAnimated:YES];
            NSString * errorStr = [NSString stringWithFormat:@"%@:%@",@"System error",obj[@"error"]];
            [Common showToast:errorStr];
        }else{
            NSMutableString *str=[obj valueForKey:@"result"];
            NSDictionary *dict = [Common dictionaryWithJsonString:[str stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"ontid"] forKey:DEFAULTONTID];
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
    }
}
-(void)createNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self setTitle:@"IMPORT ONT ID"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"ONTOBack" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
//    [self setNavRightImageIcon:[UIImage imageNamed:@"ONTODot" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
}
-(void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    _infotextview.attributedText = attributedString;
    _infotextview.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#196BD8"],
                                     NSUnderlineColorAttributeName: [UIColor colorWithHexString:@"#AAB3B4"],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    _infotextview.delegate = self;
    _infotextview.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    _infotextview.scrollEnabled = NO;
    
    
    
    
    
}
- (void)textFieldDidChange:(UITextField *)textField{
    if (_sureBtn.selected && _pswField.text.length>0 && _pswConfirmField.text.length>0) {
        _importBtn.backgroundColor = [UIColor blackColor];
        _importBtn.userInteractionEnabled = YES;
    }else{
        _importBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
        _importBtn.userInteractionEnabled = NO;
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
