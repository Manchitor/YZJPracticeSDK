//
//  SBAIPracticeProgressView.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/5.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeProgressView.h"
#import "SBAIPractice.h"

@interface SBAIPracticeProgressView ()
@property (nonatomic,strong) UIView *bg;

@property (nonatomic,strong) UILabel *progressNameLabel;
@property (nonatomic,strong) UILabel *progressLabel;

@property (nonatomic,strong) UIView *progressBgView;
@property (nonatomic,strong) UIView *progressView;

@property (nonatomic,strong) UILabel *levelLabel;


@end
@implementation SBAIPracticeProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self setupui];
    }
    return self;
}

-(void)setLevel:(NSString *)level value:(int)value name:(NSString *)name{
    self.progressNameLabel.text = name;
    self.levelLabel.text = tf_isEmptyString(level) ? @"" : level;
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",value];
    CGFloat width = SCREEN_WIDTH - 90 - 30;
    
    CGFloat progressWidth = width*value/100.0;
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(progressWidth);
    }];
    
    self.progressView.backgroundColor = [UIColor gradientColorWithSize:CGSizeMake(progressWidth, 12) direction:GradientColorDirectionLevel startColor:HEXCOLOR(0x449EFF) endColor:HEXCOLOR(0x58BFFF)];
}

-(void)setupui{
    [self addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.bg addSubview:self.progressNameLabel];
    [self.progressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(10);
        make.top.equalTo(self.bg.mas_top).offset(12);
    }];
    
    [self.bg addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.progressNameLabel);
    }];
    
    [self.bg addSubview:self.progressBgView];
    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(10);
        make.right.equalTo(self.bg.mas_right).offset(-50);
        make.top.equalTo(self.progressNameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(12);
    }];
    
    [self.bg addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(10);
        make.top.equalTo(self.progressNameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(0);
    }];
    
    [self.bg addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.centerY.equalTo(self.progressView);
    }];
    
}

#pragma mark ----------懒加载
-(UIView *)bg{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = HEXCOLOR(0xF6FAFD);
        _bg.layer.cornerRadius = 4;
        _bg.clipsToBounds = YES;
    }
    return _bg;
}

-(UILabel *)progressNameLabel{
    if (!_progressNameLabel) {
        _progressNameLabel = [[UILabel alloc] init];
        _progressNameLabel.textColor = HEXCOLOR(0x333333);
        _progressNameLabel.font = FONT_SYS_NOR(14);
    }
    return _progressNameLabel;
}

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = HEXCOLOR(0x333333);
        _progressLabel.font = FONT_SYS_NOR(14);
    }
    return _progressLabel;
}

-(UIView *)progressBgView{
    if (!_progressBgView) {
        _progressBgView = [[UIView alloc] init];
        _progressBgView.backgroundColor = HEXCOLOR(0xE5ECF1);
        _progressBgView.layer.cornerRadius = 6;
        _progressBgView.clipsToBounds = YES;
    }
    return _progressBgView;
}

-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.layer.cornerRadius = 6;
        _progressView.clipsToBounds = YES;
    }
    return _progressView;
}

-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textColor = HEXCOLOR(0x333333);
        _levelLabel.font  = FONT_SYS_NOR(14);
    }
    return _levelLabel;
}
@end
