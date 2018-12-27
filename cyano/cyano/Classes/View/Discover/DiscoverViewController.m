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
@interface DiscoverViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView  * collectionView;
@property(nonatomic,strong)NSMutableArray           * dataArray;
@property(nonatomic,strong)NSMutableArray           * viewpagerDataArray;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.viewpagerDataArray = [NSMutableArray array];
    [self createUI];
    [self getData];
}

- (void)createUI{
    
    [self setNavTitle:@"发现"];
    
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
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
        [_collectionView registerClass:[DAppCell class] forCellWithReuseIdentifier:@"_collectionView"];
        
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DAppCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"_collectionView" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        
    }else{
        [cell reloadCellByDic:_dataArray[indexPath.row]];
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    if (!jsonStr) {
        [Common showToast:@"No Wallet"];
        return;
    }
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    
    DAppViewController * vc = [[DAppViewController alloc]init];
    vc.defaultWalletDic = dict;
    vc.dAppDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat W = (SYSWidth - 2*20*SCALE_W - 3*10*SCALE_W)/4;
    if (indexPath.section == 0) {
        return CGSizeMake(SYSWidth - 40*SCALE_W, W + 30*SCALE_W);
    }
    //    CGFloat H =
    return CGSizeMake(W, W + 30*SCALE_W);
}
//调节item边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10*SCALE_W, 10*SCALE_W, 40*SCALE_W, 10*SCALE_W);
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

- (void)getData{
    [[CCRequest shareInstance] requestWithURLString1:@"http://101.132.193.149:4027/dapps" MethodType:MethodTypeGET Params:nil Success:^(id responseObject, id responseOriginal)
     {
         NSDictionary * result = responseOriginal[@"result"];
         
         //        self.dataArray = result[@"apps"];
         [self.dataArray addObjectsFromArray:result[@"apps"]];
         [self.viewpagerDataArray addObjectsFromArray:result[@"banner"]];
         [self.collectionView reloadData];
         NSLog(@"222=%@",self.dataArray);
         
     } Failure:^(NSError *error, NSString *errorDesc, id responseOriginal) {
         NSLog(@"responseOriginal=%@",responseOriginal);
         
     }];
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
