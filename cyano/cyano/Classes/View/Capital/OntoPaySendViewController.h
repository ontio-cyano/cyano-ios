//
//  OntoPaySendViewController.h
//  cyano
//
//  Created by Apple on 2018/12/24.
//  Copyright © 2018 LR. All rights reserved.
//

#import "BaseViewController.h"


@interface OntoPaySendViewController : BaseViewController
@property(nonatomic,copy)  NSString * toAddress;
@property(nonatomic,copy)  NSString * payerAddress;
@property(nonatomic,copy)  NSString * payMoney;
@property(nonatomic,copy)  NSString * callback;
@property(nonatomic,copy)  NSString * passwordString;
@property(nonatomic,copy)  NSString * hashString;
@property(nonatomic,strong)NSDictionary * payInfo;
@property(nonatomic,strong)NSDictionary * defaultDic;
@property(nonatomic,strong)NSDictionary * payDetailDic;
@property(nonatomic,assign)BOOL isONT;
@end

