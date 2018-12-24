//
//  SendViewController.h
//  cyano
//
//  Created by Apple on 2018/12/23.
//  Copyright © 2018 LR. All rights reserved.
//

#import "BaseViewController.h"



@interface SendViewController : BaseViewController
@property(nonatomic,strong)NSDictionary * walletDict;
@property(nonatomic,copy)  NSString     * ontNum;
@property(nonatomic,copy)  NSString     * ongNum;
@property(nonatomic,assign)BOOL           isONT;
@end

