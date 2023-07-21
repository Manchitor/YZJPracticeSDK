//
//  SBAIPracticeResultExplainCell.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/6.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeResultExplainCell.h"
#import "SBAIPractice.h"

@interface SBAIPracticeResultExplainCell ()
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *titleNameLabel;
@property (nonatomic,strong) UILabel *conentLabel;

@end

@implementation SBAIPracticeResultExplainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    [self setupui];
    return self;
}

-(void)setModel:(SBAIPracticeResultModel *)model{
    _model = model;
    self.conentLabel.text = tf_isEmptyString(model.standardContent) ? @"" : model.standardContent;
}

-(void)setupui{
    [self.contentView addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.bg addSubview:self.titleNameLabel];
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.bg.mas_top).offset(15);
    }];
    
    [self.bg addSubview:self.conentLabel];
    [self.conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.top.equalTo(self.titleNameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-24);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

-(UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.textColor = HEXCOLOR(0x333333);
        _titleNameLabel.font = FONT_SYS_MEDIUM(15);
        _titleNameLabel.text = @"答题详解";
    }
    return _titleNameLabel;
}

-(UILabel *)conentLabel{
    if (!_conentLabel) {
        _conentLabel = [[UILabel alloc] init];
        _conentLabel.textColor = HEXCOLOR(0x666666);
        _conentLabel.font = FONT_SYS_NOR(14);
        _conentLabel.numberOfLines = 0;
    }
    return _conentLabel;
}

@end
