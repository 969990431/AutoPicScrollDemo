//
//  ContentImageView.m
//  LunBo
//
//  Created by Aron on 2017/5/3.
//  Copyright © 2017年 XSService. All rights reserved.
//

#import "ContentImageView.h"
#import "TimeLabel.h"
#import "GoodsModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface ContentImageView ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)TimeLabel *timeLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *weightLabel;
@property (nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UIImageView *picImage;
@end
@implementation ContentImageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(9);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(14);
    }];
    
    _timeLabel = [[TimeLabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:9];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(9);
    }];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font = [UIFont systemFontOfSize:9];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.textAlignment = NSTextAlignmentRight;
    textLabel.text = @"距离结束";
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_timeLabel.mas_left);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(9);
    }];
    
    _picImage = [[UIImageView alloc]init];
    [self addSubview:_picImage];
    [_picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(9);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(127.5);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_picImage.mas_bottom).offset(5);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(14);
    }];
    
    _weightLabel = [[UILabel alloc]init];
    _weightLabel.textAlignment = NSTextAlignmentRight;
    _weightLabel.font = [UIFont systemFontOfSize:12];
    _weightLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_weightLabel];
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_picImage.mas_bottom).offset(7);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(12);
    }];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    _moneyLabel.font = [UIFont systemFontOfSize:18];
    _moneyLabel.textColor = [UIColor orangeColor];
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(18);
    }];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_weightLabel.mas_bottom).offset(9);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(12);
    }];
}
- (void)viewWithModel:(GoodsModel *)goodsModel {
    _titleLabel.text = goodsModel.title;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[goodsModel.time doubleValue]/ 1000.0];
    [formatter setDateFormat:@"HH"];
    _timeLabel.hour = [formatter stringFromDate:date].integerValue;
    [formatter setDateFormat:@"MM"];
    _timeLabel.minute = [formatter stringFromDate:date].integerValue;
    [formatter setDateFormat:@"ss"];
    _timeLabel.second = [formatter stringFromDate:date].integerValue;
    

    
    _nameLabel.text = goodsModel.name;
    _weightLabel.text = goodsModel.weight;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:goodsModel.money];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(0, 1)];
    _moneyLabel.attributedText = attributedStr;
    _numberLabel.text = goodsModel.number;
    [_picImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.picUrl]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
