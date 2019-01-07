//
//  CeshiViewController.h
//  cyano
//
//  Created by Apple on 2018/12/21.
//  Copyright © 2018 LR. All rights reserved.
//

#import "BaseViewController.h"


@interface DAppViewController : BaseViewController
@property (nonatomic,strong) NSDictionary * defaultWalletDic;
@property (nonatomic,strong) NSDictionary * dAppDic;
@property (nonatomic,copy)   NSString     * dappUrl;
@end

