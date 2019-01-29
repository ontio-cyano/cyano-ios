//
//  WalletCell.h
//  cyano
//
//  Created by Apple on 2019/1/29.
//  Copyright © 2019 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletCell : UITableViewCell
@property(nonatomic,strong)UILabel     * nameLB;
-(void)reloadCellByDic:(NSDictionary*)dic ;
@end

NS_ASSUME_NONNULL_END
