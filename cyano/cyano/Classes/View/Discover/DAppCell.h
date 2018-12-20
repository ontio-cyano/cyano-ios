//
//  DAppCell.h
//  cyano
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018 LR. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DAppCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView * icon;
@property(nonatomic,strong)UILabel * name ;
-(void)reloadCellByDic:(NSDictionary*)dic;

@end

