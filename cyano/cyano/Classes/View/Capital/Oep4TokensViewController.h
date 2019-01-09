//
//  Oep4TokensViewController.h
//  cyano
//
//  Created by Apple on 2019/1/9.
//  Copyright © 2019 LR. All rights reserved.
//

#import "BaseViewController.h"


@interface Oep4TokensViewController : BaseViewController
@property(nonatomic,strong)NSDictionary * walletDict;
@property(nonatomic,strong)NSDictionary * tokenDict;
@property(nonatomic,copy)  NSString     * ontNum;
@property(nonatomic,copy)  NSString     * ongNum;
@property(nonatomic,assign)BOOL           isONT;
@property(nonatomic,assign)BOOL           isOEP4;

@end

