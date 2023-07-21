//
//  SBAIPracticeAnalysAnswerView.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeAnalysAnswerView.h"
#import "SBAIPracticeAnswerRadarView.h"
#import "SBAIPractice.h"
@interface SBAIPracticeAnalysAnswerView ()
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *content;

@property (nonatomic,strong) SBAIPracticeAnswerRadarView *radar;

@end

@implementation SBAIPracticeAnalysAnswerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupui];
    }
    return self;
}

-(void)setModel:(SBAIPracticeAnalyzeModel *)model{
    _model = model;
    self.radar.model = model;
}

-(void)setupui{
    [self addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    
    [self.bg addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.bg.mas_top).offset(15);
    }];
    
    [self.bg addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.bg);
        make.width.height.mas_equalTo(197);
    }];
    
    self.radar = [[SBAIPracticeAnswerRadarView alloc] initWithFrame:CGRectMake(0, 0, 197, 197)];
    [self.content addSubview:self.radar];
}

#pragma mark ----------懒加载
-(UIView *)bg{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor whiteColor];
        _bg.layer.cornerRadius = 5;
        _bg.clipsToBounds = YES;
    }
    return _bg;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = FONT_SYS_MEDIUM(15);
        _titleLabel.text = @"答题分析";
    }
    return _titleLabel;
}

-(UIView *)content{
    if (!_content) {
        _content = [[UIView alloc] init];
        _content.backgroundColor = [UIColor whiteColor];
    }
    return _content;
}
@end
