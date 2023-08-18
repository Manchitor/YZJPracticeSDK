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

@property (nonatomic,strong) UIImageView *typeImg;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIImageView *calendarImgView;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *scoreView;

@property (nonatomic,strong) UILabel *scoreTitleLabel;

@property (nonatomic,strong) UILabel *scoreLabel;

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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
    [self.bgView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.height.mas_equalTo(130);
    }];
    
    [self.bgView addSubview:self.typeImg];
    [self.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.bgView addSubview:self.calendarImgView];
    [self.calendarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(9);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.bgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.calendarImgView.mas_right).offset(3);
        make.centerY.equalTo(self.calendarImgView);
    }];
    
    [self.bgView addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(9);
        make.height.mas_equalTo(36);
    }];
    
    [self.scoreView addSubview:self.scoreTitleLabel];
    [self.scoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreView.mas_left).offset(10);
        make.centerY.equalTo(self.scoreView);
    }];
    
    [self.scoreView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreTitleLabel.mas_right).offset(1);
        make.centerY.equalTo(self.scoreView);
    }];
    
    [self.bgView addSubview:self.doButton];
    [self.doButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.scoreView.mas_bottom).offset(10);
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-12);
    }];
}

-(void)setModel:(SBAIPracticeModel *)model{
    _model = model;
    
    [self.coverImageView sd_setImageWithURL:model.coverImage.toURL];
    self.nameLabel.text = model.exerciseName;
    self.timeLabel.text = [NSString stringWithFormat:@"截止时间：%@",model.offShelfDate];
    
    if (model.stageType == 0) {//0-培训，1-考核，2-培训+考核
        self.typeImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_xunlian"];
    }else if (model.stageType == 1) {//0-培训，1-考核，2-培训+考核
        self.typeImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_kaohe"];
    }else if (model.stageType == 2) {//0-培训，1-考核，2-培训+考核
        self.typeImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_xunkao"];
    }
    self.doButton.hidden = !(model.status == 1);
    
    if (model.businessStatus == 2) {//0-去完成；1-已完成；2-已过期; 3-未通过
        [self.doButton setTitle:@"已过期" forState:UIControlStateNormal];
        self.doButton.backgroundColor = HEXCOLOR(0xE8E8E8);
        [self.doButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.doButton.userInteractionEnabled = NO;
        self.doButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.doButton.layer.borderWidth = 1;
        
        self.scoreView.hidden = YES;
        [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else if (model.businessStatus == 1) {//0-去完成；1-已完成；2-已过期; 3-未通过
        [self.doButton setTitle:@"已完成" forState:UIControlStateNormal];
        self.doButton.backgroundColor = [UIColor whiteColor];
        [self.doButton setTitleColor:HEXCOLOR(0x52A0FF) forState:UIControlStateNormal];
        self.doButton.userInteractionEnabled = YES;
        self.doButton.layer.borderColor = HEXCOLOR(0x52A0FF).CGColor;
        self.doButton.layer.borderWidth = 1;
        self.scoreView.hidden = NO;
        [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
        }];
    }else if (model.businessStatus == 0) {//0-去完成；1-已完成；2-已过期; 3-未通过
        [self.doButton setTitle:@"去完成" forState:UIControlStateNormal];
        self.doButton.backgroundColor = HEXCOLOR(0x52A0FF);
        [self.doButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.doButton.userInteractionEnabled = YES;
        self.doButton.layer.borderColor = HEXCOLOR(0x52A0FF).CGColor;
        self.doButton.layer.borderWidth = 1;
        self.scoreView.hidden = YES;
        [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else if (model.businessStatus == 3) {//0-去完成；1-已完成；2-已过期; 3-未通过
        [self.doButton setTitle:@"未通过" forState:UIControlStateNormal];
        self.doButton.backgroundColor = [UIColor whiteColor];
        [self.doButton setTitleColor:HEXCOLOR(0x52A0FF) forState:UIControlStateNormal];
        self.doButton.userInteractionEnabled = YES;
        self.doButton.layer.borderColor = HEXCOLOR(0x52A0FF).CGColor;
        self.doButton.layer.borderWidth = 1;
        self.scoreView.hidden = NO;
        [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
        }];
    }
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

-(UIImageView *)typeImg{
    if (!_typeImg) {
        _typeImg = [[UIImageView alloc] init];
    }
    return _typeImg;
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

-(UIView *)scoreView{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] init];
        _scoreView.backgroundColor = HEXCOLOR(0xF4F5F6);
        _scoreView.layer.cornerRadius = 5;
        _scoreView.clipsToBounds = YES;
    }
    return _scoreView;
}

-(UILabel *)scoreTitleLabel{
    if (!_scoreTitleLabel) {
        _scoreTitleLabel = [[UILabel alloc] init];
        _scoreTitleLabel.text = @"最佳成绩：";
        _scoreTitleLabel.font = FONT_SYS_NOR(12);
        _scoreTitleLabel.textColor = HEXCOLOR(0x666666);
    }
    return _scoreTitleLabel;
}

-(UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.text = @"90";
        _scoreLabel.font = FONT_SYS_SEMIBOLD(16);
        _scoreLabel.textColor = HEXCOLOR(0x666666);
    }
    return _scoreLabel;
}

-(UIButton *)doButton{
    if (!_doButton) {
        _doButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
