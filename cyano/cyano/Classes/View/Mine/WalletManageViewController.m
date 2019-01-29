//
//  WalletManageViewController.m
//  cyano
//
//  Created by Apple on 2019/1/29.
//  Copyright © 2019 LR. All rights reserved.
//

#import "WalletManageViewController.h"
#import "CreateWalletViewController.h"
#import "WalletCell.h"
#import "WalletManageDetailViewController.h"
#import "ImportWalletViewController.h"
@interface WalletManageViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;
@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}
-(void)viewWillAppear:(BOOL)animated{
    self.dataArray = [[NSUserDefaults standardUserDefaults] valueForKey:ALLASSET_ACCOUNT];
    NSLog(@"%@",self.dataArray);
    [self.tableView reloadData];
}
-(void)configUI{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton * createButton = [[UIButton alloc]init];
    [createButton setTitle:@"CREATE WALLET" forState:UIControlStateNormal];
    [createButton setTitleColor:BLUELB forState:UIControlStateNormal];
    createButton.backgroundColor = BUTTONBACKCOLOR;
    createButton.layer.cornerRadius = 3;
    createButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:createButton];
    
    UIButton * importButton = [[UIButton alloc]init];
    [importButton setTitle:@"IMPORT WALLET" forState:UIControlStateNormal];
    [importButton setTitleColor:BLUELB forState:UIControlStateNormal];
    importButton.backgroundColor = BUTTONBACKCOLOR;
    importButton.layer.cornerRadius = 3;
    importButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.view addSubview:importButton];
    
    [createButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        CreateWalletViewController * vc = [[CreateWalletViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [importButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        ImportWalletViewController * vc = [[ImportWalletViewController alloc]init];
        vc.isWIF = YES;
        [self.navigationController pushViewController: vc animated:YES];
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34 -80*SCALE_W);
        }else{
            make.bottom.equalTo(self.view).offset(-80*SCALE_W);
        }
        
    }];
    
    [createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset((SYSWidth - 30*SCALE_W)/2);
        make.height.mas_offset(50*SCALE_W);
        make.right.equalTo(self.view.mas_centerX).offset(-5*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34 - 20*SCALE_W);
        }else{
            make.bottom.equalTo(self.view).offset(- 20*SCALE_W);
            
        }
    }];
    
    [importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset((SYSWidth - 30*SCALE_W)/2);
        make.height.mas_offset(50*SCALE_W);
        make.left.equalTo(self.view.mas_centerX).offset(5*SCALE_W);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34 - 20);
        }else{
            make.bottom.equalTo(self.view).offset(- 20);
            
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[WalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    NSDictionary * walletDic = self.dataArray[indexPath.row];
    [cell reloadCellByDic:walletDic];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * walletDic = self.dataArray[indexPath.row];
    
    WalletManageDetailViewController * vc = [[WalletManageDetailViewController alloc]init];
    vc.walletDic = walletDic;
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    if ([walletDic[@"address"] isEqualToString:dict[@"address"]]) {
        vc.isDefault = YES;
    }else{
        vc.isDefault = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
