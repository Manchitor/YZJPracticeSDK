//
//  SBAIPracticeAnalyseScoreView.m
//  Pods
//
//  Created by 刘永吉 on 2023/6/29.
//

#import "SBAIPracticeAnalyseScoreView.h"
#import "SBAIPractice.h"

@interface SBAIPracticeAnalyseScoreView ()

@property (nonatomic,strong) UIView *bg;

@property (nonatomic,strong) UIImageView *bgImg;

@property (nonatomic,strong) UILabel *finalLabel;

@property (nonatomic,strong) UILabel *finalScoreLabel;

@property (nonatomic,strong) UIButton *finalScoreDescButton;


@property (nonatomic,strong) UIView  *timeView;

@property (nonatomic,strong) UIImageView *timeImg;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *resultDescLabel;

@end

@implementation SBAIPracticeAnalyseScoreView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupui];
    }
    return self;
}

-(void)setModel:(SBAIPracticeAnalyzeModel *)model{
    _model = model;
    self.finalScoreLabel.text = [NSString stringWithFormat:@"%.2f",model.answerAnalyseScore];
    self.timeLabel.text = [SBAITool timeFormat:(model.timeSpend/1000)];
    self.resultDescLabel.text = model.prompt.length ? model.prompt : @"";
}

-(void)setupui{
    [self addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.bg addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.top.bottom.equalTo(self.bg);
    }];
    
    [self.bg addSubview:self.finalLabel];
    [self.finalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(30);
        make.top.equalTo(self.bg.mas_top).offset(33/375.0*SCREEN_WIDTH);
    }];
    
    [self.bg addSubview:self.finalScoreLabel];
    [self.finalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finalLabel.mas_right).offset(8);
        make.bottom.equalTo(self.finalLabel.mas_bottom).offset(3);
    }];
    
    [self.bg addSubview:self.finalScoreDescButton];
    [self.finalScoreDescButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finalScoreLabel.mas_right).offset(2);
        make.bottom.equalTo(self.finalLabel.mas_bottom).offset(-3);
        make.width.height.mas_equalTo(13);
    }];
    
    [self.bg addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finalScoreDescButton.mas_right).offset(15);
        make.centerY.equalTo(self.finalLabel);
        make.height.mas_equalTo(22);
    }];
    
    [self.timeView addSubview:self.timeImg];
    [self.timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView.mas_left).offset(6);
        make.centerY.equalTo(self.timeView);
        make.width.height.mas_equalTo(12);
    }];
    
    [self.timeView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImg.mas_right).offset(5);
        make.centerY.equalTo(self.timeImg);
        make.right.equalTo(self.timeView.mas_right).offset(-6);
    }];
    
    [self.bg addSubview:self.resultDescLabel];
    [self.resultDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(30);
        make.right.equalTo(self.bg.mas_right).offset(-130);
        make.top.equalTo(self.finalLabel.mas_bottom).offset(15);
    }];
}

#pragma mark ---------懒加载
-(UIView *)bg{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor clearColor];
        _bg.clipsToBounds = YES;
    }
    return _bg;
}
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.contentMode = UIViewContentModeScaleAspectFit;
        _bgImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_score_bg"];
    }
    return _bgImg;
}

-(UILabel *)finalLabel{
    if (!_finalLabel) {
        _finalLabel = [[UILabel alloc] init];
        _finalLabel.font = FONT_SYS_MEDIUM(14);
        _finalLabel.textColor = [UIColor whiteColor];
        _finalLabel.text = @"最终得分";
    }
    return _finalLabel;
}

-(UILabel *)finalScoreLabel{
    if (!_finalScoreLabel) {
        _finalScoreLabel = [[UILabel alloc] init];
        _finalScoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:25];
        _finalScoreLabel.textColor = [UIColor whiteColor];
        _finalScoreLabel.text = @"0";
    }
    return _finalScoreLabel;
}

- (UIButton *)finalScoreDescButton{
    if (!_finalScoreDescButton) {
        _finalScoreDescButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finalScoreDescButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_analyse_desc_tag"] forState:UIControlStateNormal];
    }
    return _finalScoreDescButton;
}

-(UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        _timeView.layer.cornerRadius = 11;
        _timeView.clipsToBounds = YES;
    }
    return _timeView;
}

-(UIImageView *)timeImg{
    if (!_timeImg) {
        _timeImg = [[UIImageView alloc] init];
        _timeImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_analyse_desc_tag"];
    }
    return _timeImg;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT_SYS_NOR(12);
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}

-(UILabel *)resultDescLabel{
    if (!_resultDescLabel) {
        _resultDescLabel = [[UILabel alloc] init];
        _resultDescLabel.font = FONT_SYS_NOR(12);
        _resultDescLabel.textColor = [UIColor whiteColor];
        _resultDescLabel.numberOfLines = 2;
    }
    return _resultDescLabel;
}
@end
