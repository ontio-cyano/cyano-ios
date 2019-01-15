//
//  PrivateAppViewController.m
//  cyano
//
//  Created by Apple on 2019/1/3.
//  Copyright © 2019 LR. All rights reserved.
//

#import "PrivateAppViewController.h"
#import "DAppViewController.h"
@interface PrivateAppViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation PrivateAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self configNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:PRIVATEDAPP];
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObjectsFromArray:allArray];
    [self.tableView reloadData];
}
-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.backgroundColor = WHITE;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (KIsiPhoneX) {
            make.bottom.equalTo(self.view).offset(-34);
        }else{
            make.bottom.equalTo(self.view).offset(0);
        }
        
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100*SCALE_W;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel * LB = [[UILabel alloc]init];
    LB.text = @"Private App";
    LB.textAlignment = NSTextAlignmentLeft;
    [v addSubview:LB];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = BUTTONBACKCOLOR  ;
    [v addSubview:line];
    
    UITextField * nodeField = [[UITextField alloc]init];
//    nodeField.text = self.autoNode;
    nodeField.layer.cornerRadius = 2;
    nodeField.backgroundColor = WHITE;
    nodeField.layer.borderColor = [BLUELB CGColor];;
    nodeField.layer.borderWidth = 1;
    nodeField.text = @"http://192.168.3.137:8888";
    nodeField.font= [UIFont systemFontOfSize:14];
    [v addSubview:nodeField];
    
    UIButton * sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = BLUELB;
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = [WHITE CGColor];
    [sureBtn setTitle:@"Go" forState:UIControlStateNormal];
    [sureBtn setTitleColor:WHITE forState:UIControlStateNormal];
    [v addSubview:sureBtn];
    
    [sureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
        if (!jsonStr) {
            [Common showToast:@"No Wallet"];
            return;
        }
        
        NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:PRIVATEDAPP];
        NSMutableArray *newArray;
        if (allArray) {
            newArray = [[NSMutableArray alloc] initWithArray:allArray];
        } else {
            newArray = [[NSMutableArray alloc] init];
        }
        [newArray addObject:nodeField.text];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:PRIVATEDAPP];
        
        NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
        DAppViewController * vc = [[DAppViewController alloc]init];
        vc.defaultWalletDic = dict;
        vc.dappUrl = nodeField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [nodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v).offset(60*SCALE_W);
        make.left.equalTo(v).offset(10*SCALE_W);
        make.bottom.equalTo(v).offset(-10*SCALE_W);
        make.right.equalTo(v).offset(-100*SCALE_W);
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(v).offset(-5*SCALE_W);
        make.top.equalTo(v).offset(55*SCALE_W);
        make.width.mas_offset(80*SCALE_W);
    }];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(SYSWidth);
        make.height.mas_offset(100*SCALE_W);
    }];
    
    [LB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v).offset(10*SCALE_W);
        make.top.equalTo(v).offset(15*SCALE_W);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v).offset(10*SCALE_W);
        make.right.equalTo(v).offset(-10*SCALE_W);
        make.bottom.equalTo(v.mas_bottom).offset(-1);
        make.height.mas_offset(1);
    }];
    
    return v;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*SCALE_W;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BUTTONBACKCOLOR  ;
        [cell.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10*SCALE_W);
            make.right.equalTo(cell.contentView).offset(-10*SCALE_W);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-1);
            make.height.mas_offset(1);
        }];
        
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No Wallet"];
        return;
    }
    
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    DAppViewController * vc = [[DAppViewController alloc]init];
    vc.defaultWalletDic = dict;
    vc.dappUrl = self.dataArray[indexPath.row];
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
