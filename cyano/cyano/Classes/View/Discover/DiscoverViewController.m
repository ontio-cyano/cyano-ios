//
//  DiscoverViewController.m
//  cyano
//
//  Created by Apple on 2018/12/19.
//  Copyright © 2018 LR. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DAppViewController.h"
#import "DAppCell.h"
#import "SDCycleScrollView.h"
#import "WebIdentityViewController.h"
#import "PrivateAppViewController.h"
@interface DiscoverViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UICollectionView         * collectionView;
@property(nonatomic,strong)NSMutableArray           * dataArray;
@property(nonatomic,strong)NSMutableArray           * viewpagerDataArray;
@property(nonatomic,strong)NSMutableArray           * imageArray;
@property(nonatomic,assign)BOOL                       isDapp;
@property(nonatomic,strong)UIView                   * line;
@property(nonatomic,strong)UITableView              * tableView;
@property(nonatomic,strong)NSMutableArray           * privateAppArray;

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:INVOKEPASSWORDFREE];
    [Common deleteEncryptedContent:INVOKEPASSWORDFREE];
    
    [self createUI];
    self.isDapp = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.viewpagerDataArray = [NSMutableArray array];
     self.cellDic = [[NSMutableDictionary alloc] init];
    [self getData];
    [self getPrivateAppData];
}
- (void)createUI{
    self.view.backgroundColor = WHITE;
    [self setNavTitle:@"DApp"];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view).offset(0);
        if(KIsiPhoneX){
            make.bottom.equalTo(self.view).offset(-83);
        }else{
            make.bottom.equalTo(self.view).offset(-49);
        }
    }];
    
}
- (UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor =[UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator =NO;
        _collectionView.showsVerticalScrollIndicator = NO;
//        [_collectionView registerClass:[DAppCell class] forCellWithReuseIdentifier:@"_collectionView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"_collectionView"];
        
        
    }
    return _collectionView;
}
-(UITableView*)tableView{
    if (!_tableView) {
        CGFloat W = (SYSWidth - 2*20*SCALE_W - 3*10*SCALE_W)/4;
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        if (KIsiPhoneX) {
            _tableView.frame = CGRectMake(0, 0, SYSWidth, SYSHeight - W - 130*SCALE_W -83-88);
        }else{
            _tableView.frame = CGRectMake(0, 0,  SYSWidth, SYSHeight - W - 130*SCALE_W-49-64 );
        }
        _tableView.delegate = self;
        _tableView.backgroundColor = WHITE;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (self.isDapp) {
        
        return self.dataArray.count;
    }else{
        return 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", [DAppCell class], [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[DAppCell class] forCellWithReuseIdentifier:identifier];
    }
    DAppCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SYSWidth , (SYSWidth - 2*20*SCALE_W - 3*10*SCALE_W)/4+50*SCALE_W) delegate:self placeholderImage:nil];
                                                                                                    
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        cycleScrollView.imageURLStringsGroup = self.imageArray;
        cycleScrollView.autoScrollTimeInterval = 5;
        cycleScrollView.pageDotColor = [UIColor whiteColor];
        cycleScrollView.layer.masksToBounds = YES;
        cycleScrollView.layer.cornerRadius = 2;
        [cell.contentView addSubview:cycleScrollView];
        
    }else{
        if (self.isDapp) {
            
            [cell reloadCellByDic:_dataArray[indexPath.row]];
        }else{
            [cell.contentView addSubview:self.tableView];
        }
    }
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"_collectionView" forIndexPath:indexPath];
    headerView.backgroundColor =WHITE;
   
    
    if (indexPath.section == 0) {
        headerView.hidden = YES;
    }else{
        headerView.hidden = NO;
        
        UIButton * dappBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SYSWidth/2, 50*SCALE_W)];
        [dappBtn setTitle:@"DApp" forState:UIControlStateNormal];
        [dappBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dappBtn.layer.cornerRadius = 3;
        [headerView addSubview:dappBtn];
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SYSWidth/2, 0, SYSWidth/2, 50*SCALE_W)];
        [btn setTitle:@"Private App" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        [headerView addSubview:btn];
        
        [_line removeFromSuperview];
        _line = [[UIView alloc]init];
        _line.backgroundColor = BLUELB;
        [headerView addSubview:_line];
        
        if (self.isDapp) {
            _line.frame = CGRectMake(0, 50*SCALE_W - 2, SYSWidth/2, 2);
        }else{
            _line.frame = CGRectMake(SYSWidth/2, 50*SCALE_W - 2, SYSWidth/2, 2);
        }
        
        __weak typeof(self) weakself = self;
        NSIndexSet * path = [[NSIndexSet alloc]initWithIndex:1];
        [dappBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            weakself.isDapp = YES;
            [weakself.collectionView reloadSections:path];
    
            
        }];
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            weakself.isDapp = NO;
            [weakself.collectionView reloadSections:path];
//            PrivateAppViewController *vc = [[PrivateAppViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SYSWidth, 0.01);
    }else{
        return CGSizeMake(SYSWidth, 50*SCALE_W);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No Wallet"];
        return;
    }
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    NSDictionary * dic = _dataArray[indexPath.row];
    DAppViewController * vc = [[DAppViewController alloc]init];
    vc.defaultWalletDic = dict;
    vc.dAppDic = _dataArray[indexPath.row];
    vc.dappUrl = dic[@"link"];
    [self.navigationController pushViewController:vc animated:YES];
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (SYSWidth - 2*20*SCALE_W - 3*10*SCALE_W)/4;
    if (indexPath.section == 0) {
        return CGSizeMake(SYSWidth, W + 50*SCALE_W);
    }else{
        
        if (self.isDapp) {
            return CGSizeMake(W, W + 30*SCALE_W);
        }else{
            if (KIsiPhoneX) {
                return CGSizeMake(SYSWidth, SYSHeight - W - 130*SCALE_W - 88 -83);
            }else{
                return CGSizeMake(SYSWidth, SYSHeight - W - 130*SCALE_W -49-64);
            }
            
        }
    }
}
//调节item边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0*SCALE_W, 10*SCALE_W, 20*SCALE_W, 10*SCALE_W);
    }
    if (self.isDapp) {
        return UIEdgeInsetsMake(10*SCALE_W, 10*SCALE_W, 20*SCALE_W, 10*SCALE_W);
    }else{
        return UIEdgeInsetsMake(10*SCALE_W, 10*SCALE_W, 20*SCALE_W, 10*SCALE_W);
    }
}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10*SCALE_W;
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10*SCALE_W;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSDictionary * dic = self.viewpagerDataArray[index];
    WebIdentityViewController *VC= [[WebIdentityViewController alloc]init];
    VC.introduce = dic[@"link"];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)getData{
    [[CCRequest shareInstance] requestWithURLString1:@"http://101.132.193.149:4027/dapps" MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal)
     {
         NSDictionary * result = responseOriginal[@"result"];
         
         //        self.dataArray = result[@"apps"];
         [self.dataArray addObjectsFromArray:result[@"apps"]];
         [self.viewpagerDataArray addObjectsFromArray:result[@"banner"]];
         if (self.viewpagerDataArray.count >0) {
             for (NSDictionary * dic in self.viewpagerDataArray) {
                 [self.imageArray addObject:dic[@"image"]];
             }
         }
         [self.collectionView reloadData];
         
     } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
         NSLog(@"responseOriginal=%@",responseOriginal);
         
     }];
}
-(void)getPrivateAppData{
    NSArray *allArray = [[NSUserDefaults standardUserDefaults] valueForKey:PRIVATEDAPP];
    self.privateAppArray = [NSMutableArray array];
    [self.privateAppArray addObjectsFromArray:allArray];
    [self.tableView reloadData];
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
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = BUTTONBACKCOLOR  ;
    [v addSubview:line1];
    
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
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v).offset(10*SCALE_W);
        make.right.equalTo(v).offset(-10*SCALE_W);
        make.bottom.equalTo(v.mas_bottom).offset(-1);
        make.height.mas_offset(1);
    }];
    
    return v;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.privateAppArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*SCALE_W;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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
    cell.textLabel.text = self.privateAppArray[indexPath.row];
    
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
    vc.dappUrl = self.privateAppArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
