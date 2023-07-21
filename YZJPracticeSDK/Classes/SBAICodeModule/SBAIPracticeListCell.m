//
//  SBAIPracticeListCell.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/29.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeListCell.h"
#import "SBAIPractice.h"

@interface SBAIPracticeListCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UILabel *statuesLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UIImageView *calendarImgView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *doButton;

@end

@implementation SBAIPracticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupui];
    return self;
}

-(void)setupui{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.bgView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(15);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.height.mas_equalTo(130);
    }];
    
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.bgView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(0);
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.toolView addSubview:self.calendarImgView];
    [self.calendarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolView.mas_left).offset(10);
        make.centerY.equalTo(self.toolView);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.toolView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarImgView.mas_right).offset(3);
        make.centerY.equalTo(self.toolView);
    }];
    
    [self.toolView addSubview:self.doButton];
    [self.doButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolView.mas_right).offset(-10);
        make.centerY.equalTo(self.toolView);
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(25);
    }];
}

-(void)setModel:(SBAIPracticeModel *)model{
    _model = model;
    
    [self.coverImageView sd_setImageWithURL:model.coverImage.toURL];
    self.nameLabel.text = model.exerciseName;
    self.timeLabel.text = [NSString stringWithFormat:@"截止时间：%@",model.offShelfDate];
    self.statuesLabel.text = (model.status == 1) ? @"进行中":@"已结束";
    self.doButton.hidden = !(model.status == 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark ----------页面事件
-(void)doButtonEvent{
    if (self.practiceBlock) {
        self.practiceBlock(self.model);
    }
}

#pragma mark ----------懒加载
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:0.5000].CGColor;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.shadowOffset = CGSizeMake(0,2);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 10;
        
    }
    return _bgView;
}

-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.layer.cornerRadius = 5;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

-(UILabel *)statuesLabel{
    if (!_statuesLabel){
        _statuesLabel = [[UILabel alloc] init];
        _statuesLabel.textColor = [UIColor whiteColor];
        _statuesLabel.font = FONT_SYS_NOR(11);
    }
    return _statuesLabel;
}

-(UILabel *)nameLabel{
    if (!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.font = FONT_SYS_MEDIUM(16);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xE6E6E6);
    }
    return _line;
}
-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        _toolView.layer.cornerRadius = 10;
        _toolView.clipsToBounds = YES;
        _toolView.backgroundColor = [UIColor whiteColor];
    }
    return _toolView;
}

-(UIImageView *)calendarImgView{
    if (!_calendarImgView) {
        _calendarImgView = [[UIImageView alloc] init];
        _calendarImgView.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_time"];
    }
    return _calendarImgView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = FONT_SYS_MEDIUM(12);
    }
    return _timeLabel;
}

-(UIButton *)doButton{
    if (!_doButton) {
        _doButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doButton.backgroundColor = HEXCOLOR(0x52A0FF);
        [_doButton setTitle:@"去完成" forState:UIControlStateNormal];
        [_doButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doButton.layer.cornerRadius = 12.5;
        _doButton.clipsToBounds = YES;
        _doButton.titleLabel.font = FONT_SYS_MEDIUM(12);
        [_doButton addTarget:self action:@selector(doButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doButton;
}

-(void)dealloc{
    self.practiceBlock = nil;
}
@end
