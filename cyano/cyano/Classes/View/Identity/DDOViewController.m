//
//  DDOViewController.m
//  cyano
//
//  Created by Apple on 2019/1/10.
//  Copyright © 2019 LR. All rights reserved.
//

#import "DDOViewController.h"

@interface DDOViewController ()
@property(nonatomic,strong)UITextField * keyField;
@property(nonatomic,strong)UITextField * idPswField;
@property(nonatomic,strong)UITextField * walletPswField;
@end

@implementation DDOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}
-(void)configUI{
    UILabel *typeLB = [[UILabel alloc]init];
    if (_isAdd) {
        typeLB.text = @"Add controller";
    }else{
        typeLB.text = @"Update rocover";
    }
    typeLB.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:typeLB];
    
    UILabel * publicKey = [[UILabel alloc]init];
    publicKey.textAlignment = NSTextAlignmentLeft;
    publicKey.font = [UIFont systemFontOfSize:14];
    publicKey.text = @"Public key";
    [self.view addSubview:publicKey];
    
    _keyField = [[UITextField alloc]init];
//    _keyField.delegate = self;
    _keyField.layer.borderWidth = 1;
    _keyField.layer.borderColor = [[UIColor colorWithHexString:@"#dededf"]CGColor];
    _keyField.backgroundColor = WHITE;
    [self.view addSubview:_keyField];
    
    UILabel * idPsw = [[UILabel alloc]init];
    idPsw.textAlignment = NSTextAlignmentLeft;
    idPsw.font = [UIFont systemFontOfSize:14];
    idPsw.text = @"ONT ID password";
    [self.view addSubview:idPsw];
    
    _idPswField = [[UITextField alloc]init];
    //    _keyField.delegate = self;
    _idPswField.layer.borderWidth = 1;
    _idPswField.secureTextEntry = YES;
    _idPswField.layer.borderColor = [[UIColor colorWithHexString:@"#dededf"]CGColor];
    _idPswField.backgroundColor = WHITE;
    [self.view addSubview:_idPswField];
    
    UILabel * walletAddress = [[UILabel alloc]init];
    walletAddress.textAlignment = NSTextAlignmentLeft;
    walletAddress.font = [UIFont systemFontOfSize:14];
    walletAddress.text = @"payer address";
    [self.view addSubview:walletAddress];
    
    UILabel * walletAddressLB = [[UILabel alloc]init];
    walletAddressLB.textAlignment = NSTextAlignmentLeft;
    walletAddressLB.font = [UIFont systemFontOfSize:16];
    walletAddressLB.text = _walletDic[@"address"];
    [self.view addSubview:walletAddressLB];
    
    UILabel * walletPsw = [[UILabel alloc]init];
    walletPsw.textAlignment = NSTextAlignmentLeft;
    walletPsw.font = [UIFont systemFontOfSize:14];
    walletPsw.text = @"payer password";
    [self.view addSubview:walletPsw];
    
    _walletPswField = [[UITextField alloc]init];
    //    _keyField.delegate = self;
    _walletPswField.layer.borderWidth = 1;
    _walletPswField.secureTextEntry = YES;
    _walletPswField.layer.borderColor = [[UIColor colorWithHexString:@"#dededf"]CGColor];
    _walletPswField.backgroundColor = WHITE;
    [self.view addSubview:_walletPswField];
    
    UIButton * confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmButton setTitleColor:BLUELB forState:UIControlStateNormal];
    confirmButton.backgroundColor = BUTTONBACKCOLOR;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:confirmButton];
    
    [typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(20);
    }];
    
    [publicKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.top.equalTo(typeLB.mas_bottom).offset(20);
    }];
    
    [_keyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(publicKey.mas_bottom).offset(20);
        make.height.mas_offset(30);
    }];
    
    [idPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.top.equalTo(self.keyField.mas_bottom).offset(20);
    }];
    
    [_idPswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(idPsw.mas_bottom).offset(20);
        make.height.mas_offset(30);
    }];
    
    [walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.top.equalTo(self.idPswField.mas_bottom).offset(20);
    }];
    
    [walletAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(walletAddress.mas_bottom).offset(10);
    }];
    
    [walletPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.top.equalTo(walletAddressLB.mas_bottom).offset(10);
    }];
    
    [_walletPswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLB);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(walletPsw.mas_bottom).offset(20);
        make.height.mas_offset(30);
    }];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.walletPswField.mas_bottom).offset(40);
        make.height.mas_offset(40);
        make.width.mas_offset(120);
    }];
    
}
// 导航栏设置
- (void)configNav {
    self.view.backgroundColor = WHITE;
    [self setNavLeftImageIcon:[UIImage imageNamed:@"BackWhite"] Title:Localized(@"Back")];
    
}

// 返回
- (void)navLeftAction {
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
