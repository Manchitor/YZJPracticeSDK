//
//  SBAIPracticeResultInfoCell.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/5.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeResultInfoCell.h"
#import "SBAIPractice.h"
#import <AVKit/AVKit.h>

@interface SBAIPracticeResultInfoCell ()<AVAudioPlayerDelegate>
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *questionTitleLabel;
@property (nonatomic,strong) UILabel *questionLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UIView *voiceView;
@property (nonatomic,strong) UIImageView *voiceImg;
@property (nonatomic,strong) UILabel *voiceLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *timeUnitLabel;
@property (nonatomic,strong) UIView *scoreView;
@property (nonatomic,strong) UILabel *scoreLabel;
@property (nonatomic,strong) UILabel *scoreUnitLabel;
@property (nonatomic,strong) UILabel *answerTitleLabel;
@property (nonatomic,strong) UILabel *answerLabel;

@property (nonatomic,assign) BOOL isPase;
///语音播放器
@property (nonatomic,strong)AVAudioPlayer   *audioPlayer;

@end

@implementation SBAIPracticeResultInfoCell

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
    self.questionLabel.text = model.question;
    self.answerLabel.text = model.answer;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f",model.scoreTotal];
    self.timeLabel.text = @"0";
    self.avatar.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_avatar_default"];
}

-(void)voiceEvent{
    
    if (self.audioPlayer.isPlaying){
        [self.audioPlayer pause];
        self.isPase = YES;
        self.voiceLabel.text = @"点击继续播放";
        [self stopAnimation];

    }else{//开始
        if (self.isPase){
            [self.audioPlayer play];
            [self startAnimation];

        }else{
           
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory :AVAudioSessionCategoryPlayback error:nil];
            [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
            
            
            NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.model.answerAudio]];
            NSError *error;
            self.audioPlayer = [[AVAudioPlayer alloc] initWithData:mydata error:&error];
            self.audioPlayer.delegate = self;
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
            [self startAnimation];
        }
        self.voiceLabel.text = @"点击暂停";
    }
}

-(void)startAnimation{
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    [imgArray addObject:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_emoji_jz"]];
    [imgArray addObject:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_emoji_lm"]];
    [imgArray addObject:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_emoji_qq"]];
    
    self.voiceImg.animationImages = imgArray;
    self.voiceImg.animationDuration = 3;
    self.voiceImg.animationRepeatCount = 0;
    [self.voiceImg startAnimating];

}

-(void)stopAnimation{
    [self.voiceImg stopAnimating];
    self.voiceImg.animationImages = nil;
}

#pragma mark -- delegate
// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完成");
    [self stopAnimation];
    self.voiceLabel.text = @"点击开始播放";
}

-(void)setupui{
    [self.contentView addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.bg addSubview:self.questionTitleLabel];
    [self.questionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(14);
        make.top.equalTo(self.bg.mas_top).offset(14);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.bg addSubview:self.questionLabel];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionTitleLabel.mas_right).offset(14);
        make.top.equalTo(self.questionTitleLabel.mas_top);
        make.right.equalTo(self.bg.mas_right).offset(-24);
    }];
    
    [self.bg addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.questionLabel.mas_bottom).offset(18);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.bg addSubview:self.voiceView];
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(12);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(28);
        make.centerY.equalTo(self.avatar);
    }];
    
    [self.voiceView addSubview:self.voiceImg];
    [self.voiceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceView.mas_left).offset(8);
        make.centerY.equalTo(self.voiceView);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.voiceView addSubview:self.voiceLabel];
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceImg.mas_right);
        make.right.equalTo(self.voiceView.mas_right).offset(-7);
        make.centerY.equalTo(self.voiceView);
    }];
    
    [self.bg addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceView.mas_right).offset(11);
        make.centerY.equalTo(self.voiceView);
    }];
    
    [self.bg addSubview:self.timeUnitLabel];
    [self.timeUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    [self.bg addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.centerY.equalTo(self.avatar);
        make.height.mas_equalTo(32);
    }];
    
    [self.scoreView addSubview:self.scoreUnitLabel];
    [self.scoreUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scoreView.mas_right).offset(-6);
        make.centerY.equalTo(self.scoreView);
        make.width.mas_equalTo(15);
    }];
    
    [self.scoreView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreView.mas_left).offset(6);
        make.centerY.equalTo(self.scoreView);
        make.right.equalTo(self.scoreUnitLabel.mas_left).offset(-1);
    }];
    
    [self.bg addSubview:self.answerTitleLabel];
    [self.answerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(14);
        make.top.equalTo(self.avatar.mas_bottom).offset(30);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.bg addSubview:self.answerLabel];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerTitleLabel.mas_right).offset(14);
        make.top.equalTo(self.answerTitleLabel.mas_top);
        make.right.equalTo(self.bg.mas_right).offset(-24);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-20);
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

-(UILabel *)questionTitleLabel{
    if (!_questionTitleLabel) {
        _questionTitleLabel = [[UILabel alloc] init];
        _questionTitleLabel.text = @"问";
        _questionTitleLabel.textColor = [UIColor whiteColor];
        _questionTitleLabel.backgroundColor = HEXCOLOR(0xFFB20E);
        _questionTitleLabel.font = FONT_SYS_NOR(11);
        _questionTitleLabel.layer.cornerRadius = 9;
        _questionTitleLabel.clipsToBounds = YES;
        _questionTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _questionTitleLabel;
}

-(UILabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc]init];
        _questionLabel.font = FONT_SYS_NOR(14);
        _questionLabel.textColor = HEXCOLOR(0x333333);
        _questionLabel.numberOfLines = 0;
    }
    return _questionLabel;
}

-(UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        _avatar.layer.cornerRadius = 20;
        _avatar.clipsToBounds = YES;
        _avatar.backgroundColor = [UIColor clearColor];
    }
    return _avatar;
}

-(UIView *)voiceView{
    if (!_voiceView) {
        _voiceView = [[UIView alloc] init];
        _voiceView.backgroundColor = [UIColor clearColor];
        _voiceView.layer.cornerRadius = 14;
        _voiceView.clipsToBounds = YES;
        _voiceView.layer.borderColor = HEXCOLOR(0xF1F4F7).CGColor;
        _voiceView.layer.borderWidth = 1;
        [_voiceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceEvent)]];

    }
    return _voiceView;
}

-(UIImageView *)voiceImg{
    if (!_voiceImg) {
        _voiceImg = [[UIImageView alloc] init];
    }
    return _voiceImg;
}

-(UILabel *)voiceLabel{
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] init];
        _voiceLabel.textColor = HEXCOLOR(0x52A0FF);
        _voiceLabel.font = FONT_SYS_NOR(12);
        _voiceLabel.text = @"点击开始播放";
    }
    return _voiceLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x333333);
        _timeLabel.font = FONT_SYS_NOR(12);
    }
    return _timeLabel;
}

-(UILabel *)timeUnitLabel{
    if (!_timeUnitLabel) {
        _timeUnitLabel = [[UILabel alloc] init];
        _timeUnitLabel.textColor = HEXCOLOR(0x333333);
        _timeUnitLabel.font = FONT_SYS_NOR(12);
        _timeUnitLabel.text = @"''";
    }
    return _timeUnitLabel;
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
        _scoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
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

-(UILabel *)answerTitleLabel{
    if (!_answerTitleLabel) {
        _answerTitleLabel = [[UILabel alloc] init];
        _answerTitleLabel.text = @"问";
        _answerTitleLabel.textColor = [UIColor whiteColor];
        _answerTitleLabel.backgroundColor = HEXCOLOR(0x2BDBDB);
        _answerTitleLabel.font = FONT_SYS_NOR(11);
        _answerTitleLabel.layer.cornerRadius = 9;
        _answerTitleLabel.clipsToBounds = YES;
        _answerTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _answerTitleLabel;
}

-(UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc]init];
        _answerLabel.font = FONT_SYS_NOR(14);
        _answerLabel.textColor = HEXCOLOR(0x333333);
        _answerLabel.numberOfLines = 0;
    }
    return _answerLabel;
}

@end
