//
//  SendViewController.m
//  cyano
//
//  Created by Apple on 2018/12/23.
//  Copyright © 2018 LR. All rights reserved.
//

#import "SendViewController.h"
#import "UITextField+LKLUITextField.h"
@interface SendViewController ()
<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * AssetTypeField;
@property(nonatomic,strong)UITextField * AmountLBNumField;
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
}
-(void)createUI{
    UIView * topV = [[UIView alloc]init];
    topV.backgroundColor = BLUELB;
    [self.view addSubview:topV];
    
    UILabel * alertLB = [[UILabel alloc]init];
    alertLB.text = @"Double check the address of the recipient.";
    alertLB.textColor = WHITE;
    alertLB.textAlignment = NSTextAlignmentCenter;
    alertLB.font = [UIFont systemFontOfSize:16];
    alertLB.numberOfLines = 0;
    [topV addSubview:alertLB];
    
    UILabel * RecipientLB = [[UILabel alloc]init];
    RecipientLB.text = @"Recipient";
    RecipientLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:RecipientLB];
    
    UITextField * addressLB = [[UITextField alloc]init];
    addressLB.delegate = self;
    [addressLB setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    addressLB.font = [UIFont systemFontOfSize:14];
    addressLB.layer.borderWidth = 1;
    addressLB.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:addressLB];
    
    UILabel * AssetLB = [[UILabel alloc]init];
    AssetLB.text = @"Asset";
    AssetLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:AssetLB];
    
    _AssetTypeField = [[UITextField alloc]init];
    _AssetTypeField.enabled = NO;
    _AssetTypeField.text = @"ONT";
    [_AssetTypeField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    _AssetTypeField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    _AssetTypeField.layer.borderWidth = 1;
    _AssetTypeField.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:_AssetTypeField];
    
    UILabel * AmountLB = [[UILabel alloc]init];
    AmountLB.text = @"Amount";
    AmountLB.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:AmountLB];
    
    _AmountLBNumField = [[UITextField alloc]init];
    _AmountLBNumField.text = @"0";
    [_AmountLBNumField setTextFieldPlaceholderString:@"" leftImageView:nil paddingLeft:15];
    _AmountLBNumField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _AmountLBNumField.layer.borderWidth = 1;
    _AmountLBNumField.layer.borderColor = [[UIColor blackColor]CGColor];
    [self.view addSubview:_AmountLBNumField];
    
    UIButton * confirmBtn = [[UIButton alloc]init];
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:BLUELB forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [confirmBtn.titleLabel changeSpace:0 wordSpace:1];
    confirmBtn.backgroundColor = BUTTONBACKCOLOR;
    [self.view addSubview:confirmBtn];
    
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    [alertLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20*SCALE_W);
        make.right.equalTo(self.view).offset(-20*SCALE_W);
        make.top.equalTo(self.view).offset(20*SCALE_W);
        make.bottom.equalTo(topV.mas_bottom).offset(-40*SCALE_W);
    }];
    
    [RecipientLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(topV.mas_bottom).offset(20*SCALE_W);
    }];
    
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(RecipientLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [AssetLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(addressLB.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_AssetTypeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(AssetLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [AmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.top.equalTo(self.AssetTypeField.mas_bottom).offset(20*SCALE_W);
    }];
    
    [_AmountLBNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10*SCALE_W);
        make.right.equalTo(self.view).offset(-10*SCALE_W);
        make.top.equalTo(AmountLB.mas_bottom).offset(10*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(58*SCALE_W);
        make.right.equalTo(self.view).offset(-58*SCALE_W);
        make.height.mas_offset(60*SCALE_W);
        make.bottom.equalTo(self.view).offset(-100*SCALE_W);
    }];
}
- (void)createNav{
    self.view.backgroundColor = WHITE;
    [self setNavTitle:@"Send"];
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
