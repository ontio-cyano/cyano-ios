//
//  TokensCell.h
//  cyano
//
//  Created by Apple on 2019/1/9.
//  Copyright © 2019 LR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TokensCell : UITableViewCell
@property(nonatomic,strong)UILabel     * nameLB;
@property(nonatomic,strong)UIImageView * tokenImageView;
@property(nonatomic,strong)UILabel     * amountLB;
-(void)reloadCellByDic:(NSDictionary*)dic ;
@end

