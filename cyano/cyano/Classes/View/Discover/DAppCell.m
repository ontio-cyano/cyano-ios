//
//  DAppCell.m
//  cyano
//
//  Created by Apple on 2018/12/20.
//  Copyright © 2018 LR. All rights reserved.
//

#import "DAppCell.h"

@implementation DAppCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUpAllChildView];
    }
    return self;
}
-(void)setUpAllChildView{
    _icon = [[UIImageView alloc]init];
    [self.contentView addSubview:_icon];
    
    _name = [[UILabel alloc]init];
    [self.contentView addSubview:_name];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5*SCALE_W);
        make.width.height.mas_offset(self.contentView.width-20*SCALE_W);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(10*SCALE_W);
    }];
}
-(void)reloadCellByDic:(NSDictionary *)dic{
//    _name
    [_icon sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    _name.text = dic[@"name"];
}
@end
