//
//  ChangeNodeViewController.m
//  cyano
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 LR. All rights reserved.
//

#import "ChangeNodeViewController.h"

@interface ChangeNodeViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray     * testNodeArray;
@property(nonatomic,strong)NSArray     * mainNodeArray;
@property(nonatomic,copy)  NSString    * autoNode;
@end

@implementation ChangeNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}
-(void)configUI{
    self.mainNodeArray = @[@"http://dappnode1.ont.io:20334",
                          @"http://dappnode2.ont.io:20334",
                          @"http://dappnode3.ont.io:20334",
                          @"http://dappnode4.ont.io:20334"];
    
    self.testNodeArray = @[@"http://polaris1.ont.io:20334",
                           @"http://polaris2.ont.io:20334",
                           @"http://polaris3.ont.io:20334",
                           @"http://polaris4.ont.io:20334",
                           @"http://polaris5.ont.io:20334",];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 3) {
        return 0;
    }else if (section ==1){
        return 5;
    }else{
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*SCALE_W;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 50*SCALE_W)];
//    headV.backgroundColor = BLUELB;
    
    UILabel * sectionLB = [[UILabel alloc]init];
    sectionLB.textColor = BLUELB;
    sectionLB.font = [UIFont systemFontOfSize:14];
    [headV addSubview:sectionLB];
    
    [sectionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV);
        make.left.equalTo(headV).offset(10*SCALE_W);
        make.right.equalTo(headV).offset(-10*SCALE_W);
        make.height.mas_offset(50*SCALE_W);
    }];
    if (section == 0 ) {
        sectionLB.text = [NSString stringWithFormat:@"The current node: %@",[[NSUserDefaults standardUserDefaults] valueForKey:TESTNETADDR]];
    }else if (section == 1){
        sectionLB.text = @"Test network node";
    }else if (section == 2){
        sectionLB.text = @"Main network node";
    }else{
        sectionLB.text = @"Private network node";
        
        UITextField * nodeField = [[UITextField alloc]init];
        nodeField.text = self.autoNode;
        nodeField.layer.cornerRadius = 2;
        nodeField.backgroundColor = WHITE;
        nodeField.layer.borderColor = [BLUELB CGColor];;
        nodeField.layer.borderWidth = 1;
        nodeField.text = @"http://127.0.0.1:20334";
        nodeField.font= [UIFont systemFontOfSize:14];
        [headV addSubview:nodeField];
        
        UIButton * sureBtn = [[UIButton alloc]init];
        sureBtn.backgroundColor = BLUELB;
        sureBtn.layer.cornerRadius = 3;
        sureBtn.layer.borderWidth = 1;
        sureBtn.layer.borderColor = [WHITE CGColor];
        [sureBtn setTitle:@"confirm" forState:UIControlStateNormal];
        [sureBtn setTitleColor:WHITE forState:UIControlStateNormal];
        [headV addSubview:sureBtn];
        
        [nodeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headV).offset(60*SCALE_W);
            make.left.equalTo(headV).offset(10*SCALE_W);
            make.bottom.equalTo(headV).offset(-10*SCALE_W);
            make.right.equalTo(headV).offset(-100*SCALE_W);
        }];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(headV).offset(-5*SCALE_W);
            make.top.equalTo(headV).offset(55*SCALE_W);
            make.width.mas_offset(80*SCALE_W);
        }];
        
        [sureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            if ([Common isBlankString:nodeField.text]) {
                return ;
            }
            
            self.autoNode = nodeField.text;
            [[NSUserDefaults standardUserDefaults]setValue:nodeField.text forKey:TESTNETADDR];
            [tableView reloadData];
        }];
    }
    return headV;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYSWidth, 1)];
    lineV.backgroundColor = BUTTONBACKCOLOR;
    return lineV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 100*SCALE_W;
    }
    return 50*SCALE_W;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 0.01;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UILabel * nodeLB = [[UILabel alloc]init];
//        nodeLB.textColor = BLUELB;
        nodeLB.tag = 1001;
        nodeLB.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nodeLB];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BUTTONBACKCOLOR  ;
        [cell.contentView addSubview:line];
        
        [nodeLB  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10*SCALE_W);
            make.right.equalTo(cell.contentView).offset(-10*SCALE_W);
            make.top.bottom.equalTo(cell.contentView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(0*SCALE_W);
            make.right.equalTo(cell.contentView).offset(0*SCALE_W);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(0);
            make.height.mas_offset(1);
        }];
    }
    UILabel * nodeDetailLB = [cell.contentView viewWithTag:1001];
    if (indexPath.section == 1) {
        nodeDetailLB.text = self.testNodeArray[indexPath.row];
    }else if (indexPath.section == 2){
        nodeDetailLB.text = self.mainNodeArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSArray * node1 = [self.testNodeArray[indexPath.row] componentsSeparatedByString:@"//"];
        NSArray * node2 = [node1[1] componentsSeparatedByString:@":"];
         [[NSUserDefaults standardUserDefaults]setValue:node2[0] forKey:TESTNETADDR];
        [[NSUserDefaults standardUserDefaults]setValue:@"https://polarisexplorer.ont.io" forKey:CAPITALURI];
        [[NSUserDefaults standardUserDefaults]setValue:@"https://explorer.ont.io/address/%@/20/1/testnet" forKey:RECORDURI];
    }else if (indexPath.section == 2){
        NSArray * node1 = [self.mainNodeArray[indexPath.row] componentsSeparatedByString:@"//"];
        NSArray * node2 = [node1[1] componentsSeparatedByString:@":"];
         [[NSUserDefaults standardUserDefaults]setValue:node2[0] forKey:TESTNETADDR];
        [[NSUserDefaults standardUserDefaults]setValue:@"https://explorer.ont.io" forKey:CAPITALURI];
        [[NSUserDefaults standardUserDefaults]setValue:@"https://explorer.ont.io/address/%@/20/1" forKey:RECORDURI];
    }
    [tableView reloadData];
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
