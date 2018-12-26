//
//  ScanViewController.h
//  cyano
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018 LR. All rights reserved.
//

#import "BaseViewController.h"

typedef enum:NSInteger {
    
    ScanNormal = 0,
    ScanWithDraw
    
}ScanType;
@interface ScanViewController : BaseViewController
//todo 枚举
@property (nonatomic, assign) BOOL isWallet; //创建钱包
@property (nonatomic, assign) BOOL isVerb;   //转账流程二维码
@property (nonatomic, assign) BOOL isReceiverAddress; //接收地址信息
@property (nonatomic, assign) BOOL isShareWalletAddress; //共享钱包
@property (nonatomic, assign) BOOL isCOT;//cot
@property (nonatomic, copy) void (^callback)(NSString *);
@property (nonatomic, assign) BOOL isImportWallet; //重新导入
@property (nonatomic, assign) BOOL isKeyStore;//keystore导入
@property (nonatomic, assign) BOOL isThired;//第三方
@property (nonatomic, assign) BOOL isPay;//支付
@property(nonatomic, assign) ScanType scanType;
@property(nonatomic, strong) NSDictionary *refInfoDic; //kyc认证的数据
@end

