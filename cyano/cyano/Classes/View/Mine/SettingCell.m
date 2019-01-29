//
//  SettingCell.m
//  cyano
//
//  Created by Apple on 2019/1/29.
//  Copyright © 2019 LR. All rights reserved.
//

#import "SettingCell.h"
#import "Config.h"
@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WHITE;
        
        _nameLB = [[UILabel alloc]init];
        _nameLB.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLB];
        
        _ImageView = [[UIImageView alloc]init];
        [self addSubview:_ImageView];
        
        UIView * line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#E2EAF2"];
        [self addSubview:line];
        
        UIImageView * rightImage = [[UIImageView alloc]init];
        rightImage.image = [UIImage imageNamed:@"JT"];
        [self addSubview:rightImage];
        
        [_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
            make.width.height.mas_offset(20);
        }];
        
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ImageView.mas_right).offset(10);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
