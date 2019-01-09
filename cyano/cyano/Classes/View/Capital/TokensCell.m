//
//  TokensCell.m
//  cyano
//
//  Created by Apple on 2019/1/9.
//  Copyright © 2019 LR. All rights reserved.
//

#import "TokensCell.h"
#import "Config.h"
@implementation TokensCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TABLEBACKCOLOR;
        
        _nameLB = [[UILabel alloc]init];
        _nameLB.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLB];
        
        _tokenImageView = [[UIImageView alloc]init];
        [self addSubview:_tokenImageView];
        
        _amountLB = [[UILabel alloc]init];
        _amountLB.textAlignment = NSTextAlignmentRight;
        [self addSubview:_amountLB];
        
        UIView* line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#E2EAF2"];
        [self addSubview:line];
        
        [_tokenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.width.height.mas_offset(25);
        }];
        
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tokenImageView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        
        [_amountLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self);
            make.height.mas_offset(1);
        }];
    }
    return self;
}
-(void)reloadCellByDic:(NSDictionary*)dic {
    _nameLB.text = dic[@"Symbol"];
    [_tokenImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"Logo"]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
