//
//  WalletCell.m
//  cyano
//
//  Created by Apple on 2019/1/29.
//  Copyright © 2019 LR. All rights reserved.
//

#import "WalletCell.h"
#import "Config.h"
@implementation WalletCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WHITE;
        
        _nameLB = [[UILabel alloc]init];
        _nameLB.textAlignment = NSTextAlignmentLeft;
        _nameLB.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _nameLB.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [self addSubview:_nameLB];
        
        UIView * line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#E2EAF2"];
        [self addSubview:line];
        
        UIImageView * rightImage = [[UIImageView alloc]init];
        rightImage.image = [UIImage imageNamed:@"JT"];
        [self addSubview:rightImage];
        
        
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-35);
            make.centerY.equalTo(self);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self);
            make.height.mas_offset(1);
        }];
        
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
            make.width.mas_offset(6);
            make.height.mas_offset(11.5);
        }];
    }
    return self;
}
-(void)reloadCellByDic:(NSDictionary*)dic{
    _nameLB.text = dic[@"address"];
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults] valueForKey:ASSET_ACCOUNT];
    NSDictionary *dict = [Common dictionaryWithJsonString:jsonStr];
    if ([dic[@"address"] isEqualToString:dict[@"address"]]) {
        _nameLB.textColor = BLUELB;
    }else{
        _nameLB.textColor = [UIColor blackColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
