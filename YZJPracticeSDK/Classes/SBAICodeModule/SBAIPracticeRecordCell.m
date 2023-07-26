//
//  SBAIPracticeRecordCell.m
//  Pods
//
//  Created by 刘永吉 on 2023/6/29.
//

#import "SBAIPracticeRecordCell.h"
#import "SBAIPractice.h"

@interface SBAIPracticeRecordCell ()

@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *scoreLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UIView *line;

@end
@implementation SBAIPracticeRecordCell

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

-(void)setModel:(SBAIPracticeTrainingRecordModel *)model{
    _model = model;
    
    self.timeLabel.text = model.exerciseDate;
    self.typeLabel.text = model.stageType == 0 ? @"培训" :@"考核";//0 培训；1考核
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f",model.answerAnalyseScore];
}

-(void)setupui{
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
    [self.bg addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-95);
        make.top.equalTo(self.bg.mas_top).offset(13);
    }];
    
    [self.bg addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(2);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-13);
    }];
    
    [self.bg addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.centerY.equalTo(self.bg);
    }];
    
    [self.bg addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)bg{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor whiteColor];
        _bg.layer.cornerRadius = 5;
        _bg.clipsToBounds = YES;
    }
    return _bg;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x333333);
        _timeLabel.font = FONT_SYS_NOR(14);
    }
    return _timeLabel;
}

-(UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEXCOLOR(0x333333);
//        _scoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
        _scoreLabel.font = FONT_SYS_MEDIUM(16);

    }
    return _scoreLabel;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = HEXCOLOR(0x999999);
        _typeLabel.font = FONT_SYS_NOR(12);
    }
    return _typeLabel;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xE8EBEF);
    }
    return _line;
}
@end
