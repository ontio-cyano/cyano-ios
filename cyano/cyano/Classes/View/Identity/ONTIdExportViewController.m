//
//  ONTIdExportViewController.m
//  cyano
//
//  Created by Apple on 2019/1/28.
//  Copyright © 2019 LR. All rights reserved.
//

#import "ONTIdExportViewController.h"
#import "UITextView+Placeholder.h"
@interface ONTIdExportViewController ()
@property(nonatomic,strong)UITextView  * textView;
@end

@implementation ONTIdExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
}

-(void)createUI{
    UILabel * topLB = [[UILabel alloc]init];
    topLB.text = @"Please save the private key (WIF format) to a secure environment";
    topLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    topLB.numberOfLines = 0;
    [topLB changeSpace:0 wordSpace:0.5];
    [self.view addSubview:topLB];
    
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _textView.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    _textView.editable = NO;
    _textView.text = self.WIFString;
    [self.view addSubview:_textView];
    
    UIButton * whatBtn = [[UIButton alloc]init];
    [whatBtn setImage:[UIImage imageNamed:@"ONTOBlueInfo" inBundle:ONTOBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [whatBtn setTitle:@"What is Private Key (WIF format)?" forState:UIControlStateNormal];
    [whatBtn setTitleColor:[UIColor colorWithHexString:@"#196BD8"] forState:UIControlStateNormal];
    whatBtn.titleEdgeInsets = UIEdgeInsetsMake(whatBtn.frame.size.height-whatBtn.imageView.frame.size.height-whatBtn.imageView.frame.origin.y, -whatBtn.imageView.frame.size.width +10, 0, 0);
    whatBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    whatBtn.titleLabel.numberOfLines = 0;
    [self.view addSubview:whatBtn];
    
    UIButton * copyBtn = [[UIButton alloc]init];
    [copyBtn setTitle:@"COPY" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyBtn.backgroundColor = [UIColor blackColor];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    copyBtn.layer.cornerRadius = 0.5;
    [copyBtn.titleLabel changeSpace:0 wordSpace:1];
    [copyBtn addTarget:self action:@selector(copyOntId) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBtn];
    
    [topLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
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
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
-(void)copyOntId{
    [Common showToast:@"WIF COPIED!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.WIFString;
}
-(void)createNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self setTitle:@"EXPORT ONT ID"];
    [self setNavLeftImageIcon:[UIImage imageNamed:@"ONTOBack" inBundle:ONTOBundle compatibleWithTraitCollection:nil] Title:@""];
}
-(void)navLeftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
