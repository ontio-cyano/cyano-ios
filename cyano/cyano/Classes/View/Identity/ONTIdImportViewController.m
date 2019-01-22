//
//  ONTIdImportViewController.m
//  cyano
//
//  Created by Apple on 2019/1/21.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTIdImportViewController.h"
#import "UITextView+Placeholder.h"
@interface ONTIdImportViewController ()
<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITextView  * textView;
@property(nonatomic,strong)UITextField * pswField;
@property(nonatomic,strong)UITextView  * infotextview;
@property(nonatomic,strong)UIButton    * sureBtn;
@property(nonatomic,strong)UIButton    * importBtn;
@end

@implementation ONTIdImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
}
-(void)createUI{
    UILabel * topLB = [[UILabel alloc]init];
    topLB.text = @"ONT ID Private Key (WIF format) Import";
    topLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [topLB changeSpace:0 wordSpace:0.5];
    [self.view addSubview:topLB];
    
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _textView.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    _textView.placeholderLabel.text = @"Please paste your Private Key (WIF format) here.";
    [self.view addSubview:_textView];
    
    UIButton * whatBtn = [[UIButton alloc]init];
    [whatBtn setImage:[UIImage imageNamed:@"ONTOBlueInfo" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [whatBtn setTitle:@"What is Private Key (WIF format)?" forState:UIControlStateNormal];
    [whatBtn setTitleColor:[UIColor colorWithHexString:@"#196BD8"] forState:UIControlStateNormal];
    whatBtn.titleEdgeInsets = UIEdgeInsetsMake(whatBtn.frame.size.height-whatBtn.imageView.frame.size.height-whatBtn.imageView.frame.origin.y, -whatBtn.imageView.frame.size.width +10, 0, 0);
    whatBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    whatBtn.titleLabel.numberOfLines = 0;
    [self.view addSubview:whatBtn];
    
    UILabel * OntPsw = [[UILabel alloc]init];
    OntPsw.text = @"ONT ID Password";
    [OntPsw changeSpace:0 wordSpace:1];
    OntPsw.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.view addSubview:OntPsw];
    
    _pswField = [[UITextField alloc]init];
    _pswField.placeholder = @"6 digits";
    _pswField.secureTextEntry = YES;
    _pswField.keyboardType = UIKeyboardTypeNumberPad;
    _pswField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _pswField.textColor = [UIColor colorWithHexString:@"#6E6F70"];
    [self.view addSubview:_pswField];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:line];
    
    _sureBtn = [[UIButton alloc]init];
    [_sureBtn setImage:[UIImage imageNamed:@"ONTOunselect" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_sureBtn setImage:[UIImage imageNamed:@"ONTOSelected" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    _sureBtn.selected = NO;
    [self.view addSubview:_sureBtn];
    
    _infotextview = [[UITextView alloc] init];
    [self protocolIsSelect:NO];
    [self.view addSubview:_infotextview];
    
    _importBtn = [[UIButton alloc]init];
    [_importBtn setTitle:@"IMPORT" forState:UIControlStateNormal];
    [_importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _importBtn.backgroundColor = [UIColor colorWithHexString:@"#9B9B9B"];
    _importBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    _importBtn.layer.cornerRadius = 0.5;
    [_importBtn.titleLabel changeSpace:0 wordSpace:1];
    _importBtn.selected = NO;
    [self.view addSubview:_importBtn];
    
    [topLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(30);
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
        make.top.equalTo(OntPsw.mas_bottom).offset(14);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.pswField.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(OntPsw);
        make.top.equalTo(line.mas_bottom).offset(25);
    }];
    
    [_infotextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sureBtn.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.sureBtn).offset(-5);
    }];
    
    [_importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58);
        make.right.equalTo(self.view).offset(-58);
        make.height.mas_offset(60);
        if (ONTOIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34 - 40);
        }else{
            make.bottom.equalTo(self.view).offset(-40);
        }
    }];
}
-(void)createNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self setTitle:@"IMPORT ONT ID"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:@""];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"ONTOBack" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
    [self setNavRightImageIcon:[UIImage imageNamed:@"ONTODot" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
}
-(void)navLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)protocolIsSelect:(BOOL)select {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"I agreed with Terms of Service and Privacy Policy."];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"zhifubao://"
                             range:[[attributedString string] rangeOfString:@"Terms of Service"]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"weixin://"
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
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL scheme] isEqualToString:@"zhifubao"]) {
        NSLog(@"111");
        //        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        //        vc.proction = APPTERMS;
        //
        //        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"weixin"]) {
        NSLog(@"222");
        //        WebIdentityViewController *vc = [[WebIdentityViewController alloc]init];
        //        vc.proction = APPPRIVACY;
        //
        //        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
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
