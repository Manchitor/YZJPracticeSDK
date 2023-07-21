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
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *scoreView;
@property (nonatomic,strong) UILabel *scoreLabel;
@property (nonatomic,strong) UILabel *scoreUnitLabel;

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
    self.nameLabel.text = model.exerciseName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f",model.answerAnalyseScore];
    self.timeLabel.text = model.exerciseDate;
}

-(void)setupui{
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
    [self.bg addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-95);
        make.top.equalTo(self.bg.mas_top).offset(15);
    }];
    
    [self.bg addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-15);
    }];
    
    [self.bg addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.centerY.equalTo(self.bg);
        make.height.mas_equalTo(32);
    }];
    
    
    [self.scoreView addSubview:self.scoreUnitLabel];
    [self.scoreUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scoreView.mas_right).offset(-6);
        make.centerY.equalTo(self.scoreView);
        make.width.mas_equalTo(13);
    }];
    
    [self.scoreView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreView.mas_left).offset(6);
        make.right.equalTo(self.scoreUnitLabel.mas_left).offset(-1);
        make.centerY.equalTo(self.scoreView);
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

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.font = FONT_SYS_MEDIUM(14);
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = FONT_SYS_NOR(14);
    }
    return _timeLabel;
}

-(UIView *)scoreView{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] init];
        _scoreView.backgroundColor = HEXCOLOR(0xF4F6F7);
        _scoreView.layer.cornerRadius = 8;
        _scoreView.clipsToBounds = YES;
    }
    return _scoreView;
}
-(UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEXCOLOR(0x263858);
        _scoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    }
    return _scoreLabel;
}

-(UILabel *)scoreUnitLabel{
    if (!_scoreUnitLabel) {
        _scoreUnitLabel = [[UILabel alloc] init];
        _scoreUnitLabel.textColor = HEXCOLOR(0x263858);
        _scoreUnitLabel.font = FONT_SYS_NOR(12);
        _scoreUnitLabel.text = @"分";
    }
    return _scoreUnitLabel;
}
@end
