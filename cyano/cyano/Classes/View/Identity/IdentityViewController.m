//
//  IdentityViewController.m
//  cyano
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "IdentityViewController.h"
#import "CreateIdentityViewController.h"
#import "ImportIdentityViewController.h"
@interface IdentityViewController ()
@property(nonatomic,strong)UIView  * bgView;
@property(nonatomic,strong)UIView  * IdentityView;
@property(nonatomic,strong)UILabel * ontidLB;
@property(nonatomic,strong)NSDictionary * idDic;

@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"My identity"];
    [self createEmptyIdentityV];
    [self createIdentityView];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :
                                                                          [UIColor colorWithHexString:@"#ffffff"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]}];
    NSString *str =  [[NSUserDefaults standardUserDefaults] objectForKey:APP_ACCOUNT];
    if(str == nil){
        _bgView.hidden = NO;
        _IdentityView.hidden = YES;
    }else{
        _bgView.hidden = YES;
        _IdentityView.hidden = NO;
        NSDictionary *jsDic= [self parseJSONStringToNSDictionary:str];
        self.idDic = jsDic;
        _ontidLB.text = [NSString stringWithFormat:@"Registered ONT ID\n%@",self.idDic[@"ontid"]];
        NSLog(@"jsDic=%@",jsDic);
    }
    
}
-(void)createIdentityView{
    
    _IdentityView = [[UIView alloc]init];
    _IdentityView.hidden = NO;
    _IdentityView.backgroundColor = TABLEBACKCOLOR;
    [self.view addSubview:_IdentityView];
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = BLUELB;
    [_IdentityView addSubview:topView];
    
    
    _ontidLB = [[UILabel alloc]init];
    _ontidLB.textColor = WHITE;
    _ontidLB.numberOfLines = 0;
    
    _ontidLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _ontidLB.textAlignment = NSTextAlignmentLeft;
    [_IdentityView addSubview:_ontidLB];
    
    [_IdentityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.IdentityView);
        //        make.height.mas_offset(150*SCALE_W);
    }];
    
    [_ontidLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15*SCALE_W);
        make.right.equalTo(self.view).offset(-15*SCALE_W);
        make.top.equalTo(self.IdentityView).offset(20*SCALE_W);
        make.bottom.equalTo(topView.mas_bottom).offset(-50*SCALE_W);
    }];
}
- (void)createEmptyIdentityV{
    _bgView = [[UIView alloc]init];
    _bgView.hidden = NO;
    [self.view addSubview:_bgView];
    
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"capitalLogo"];
    [_bgView addSubview:logoImage];
    
    UILabel * nameLB = [[UILabel alloc]init];
    nameLB.textColor = [UIColor whiteColor];
    nameLB.text =@"Ontology Identity";
    nameLB.textAlignment = NSTextAlignmentCenter;
    nameLB.font = [UIFont systemFontOfSize:28];
    [nameLB changeSpace:0 wordSpace:1];
    [_bgView addSubview:nameLB];
    
    UILabel * alertLB = [[UILabel alloc]init];
    alertLB.textColor = [UIColor whiteColor];
    alertLB.numberOfLines = 0;
    alertLB.text = @"You don't have registered your identity yet.\nCreate new identity or import existing.";
    alertLB.font = [UIFont systemFontOfSize:16];
    [alertLB changeSpace:2 wordSpace:0];
    alertLB.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:alertLB];
    
    UIButton * createButton = [[UIButton alloc]init];
    createButton.backgroundColor = BUTTONBACKCOLOR;
    [createButton setTitle:@"NEW IDENTITY" forState:UIControlStateNormal];
    [createButton setTitleColor:BLUELB forState:UIControlStateNormal];
    createButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_bgView addSubview:createButton];
    
    UIButton * importButton = [[UIButton alloc]init];
    importButton.backgroundColor = BUTTONBACKCOLOR;
    [importButton setTitle:@"IMPORT IDENTITY" forState:UIControlStateNormal];
    [importButton setTitleColor:BLUELB forState:UIControlStateNormal];
    importButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [_bgView addSubview:importButton];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [createButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
        if (jsonStr) {
            NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
            CreateIdentityViewController * vc = [[CreateIdentityViewController alloc]init];
            vc.walletDic = dict;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [Common showToast:@"No Wallet"];
        }
        
    }];
    
    [importButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        ImportIdentityViewController * vc = [[ImportIdentityViewController alloc]init];
        vc.isWIF = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
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
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
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
