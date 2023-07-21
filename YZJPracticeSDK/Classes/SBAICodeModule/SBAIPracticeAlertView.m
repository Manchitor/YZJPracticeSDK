//
//  SBAIPracticeAlertView.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/7.
//

#import "SBAIPracticeAlertView.h"
#import "SBAIPractice.h"

@interface SBAIPracticeAlertView ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation SBAIPracticeAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupui];
    }
    return self;
}

-(void)setupui{
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
 
}

-(void)setAlertText:(NSString *)alertText{
    if (alertText.length){
        self.contentLabel.text = alertText;
    }
}

#pragma mark --------懒加载
-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = FONT_SYS_NOR(18);
        _titleLabel.text = @"提示";
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = FONT_SYS_NOR(16);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
@end
