//
//  SBAIPracticeResultAnalyzeCell.m
//  Pods
//
//  Created by 刘永吉 on 2023/7/5.
//

#import "SBAIPracticeResultAnalyzeCell.h"
#import "SBAIPractice.h"
#import "SBAIPracticeProgressView.h"

@interface SBAIPracticeResultAnalyzeCell ()
@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *analyzeTitleLabel;
@property (nonatomic,strong) UIButton *analyzeDescButton;

@property (nonatomic,strong) UIView *evaluateView;
@property (nonatomic,strong) UILabel *evaluateLabel;
@property (nonatomic,strong) UIButton *evaluateUpButton;
@property (nonatomic,strong) UIButton *evaluateDownButton;


@property (nonatomic,strong) UIView *keywordsView;
@property (nonatomic,strong) UILabel *keywordsTitleLabel;
@property (nonatomic,strong) UILabel *keywordsValueLabel;
@property (nonatomic,strong) UILabel *keywordsLabel;

@property (nonatomic,strong) SBAIPracticeProgressView *formulationView;
@property (nonatomic,strong) SBAIPracticeProgressView *contentPView;
@property (nonatomic,strong) SBAIPracticeProgressView *coherentView;
@property (nonatomic,strong) SBAIPracticeProgressView *logicView;
@property (nonatomic,strong) SBAIPracticeProgressView *affineView;
@property (nonatomic,strong) SBAIPracticeProgressView *activelyView;
@property (nonatomic,strong) SBAIPracticeProgressView *politenessView;


@end

@implementation SBAIPracticeResultAnalyzeCell

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
    
    self.keywordsLabel.text = tf_isEmptyString(model.keywords) ? @"" : model.keywords;
    self.keywordsValueLabel.text = [NSString stringWithFormat:@"%d%%",model.scoreHitrate];
    
    [self.formulationView setLevel:model.scoreLevel value:model.scoreCorrect name:@"表述准确"];
    [self.contentPView setLevel:model.scoreCompleteLevel value:model.scoreComplete name:@"内容完整"];
    [self.coherentView setLevel:model.scoreCoherenceLevel value:model.scoreCoherence name:@"话语连贯"];
    [self.logicView setLevel:model.scoreLogicLevel value:model.scoreLogic name:@"语言逻辑"];
    [self.affineView setLevel:model.scoreCaterLevel value:model.scoreCater name:@"语言亲和"];
    [self.activelyView setLevel:model.scorePositiveLevel value:model.scorePositive name:@"积极态度"];
    [self.politenessView setLevel:model.scorePoliteLevel value:model.scorePolite name:@"礼貌用语"];
}

-(void)setupui{
    [self.contentView addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
    [self.bg addSubview:self.analyzeTitleLabel];
    [self.analyzeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.top.equalTo(self.bg.mas_top).offset(15);
    }];
    
    [self.bg addSubview:self.analyzeDescButton];
    [self.analyzeDescButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.analyzeTitleLabel.mas_right).offset(8);
        make.centerY.equalTo(self.analyzeTitleLabel);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.bg addSubview:self.evaluateView];
    [self.evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.top.equalTo(self.analyzeTitleLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(120);
    }];
    
    [self.evaluateView addSubview:self.evaluateLabel];
    [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.evaluateView);
        make.top.equalTo(self.evaluateView.mas_top).offset(30);
    }];
    
    [self.evaluateView addSubview:self.evaluateUpButton];
    [self.evaluateUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.evaluateView.mas_centerX).offset(-45);
        make.top.equalTo(self.evaluateLabel.mas_bottom).offset(15);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.evaluateView addSubview:self.evaluateDownButton];
    [self.evaluateDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.evaluateView.mas_centerX).offset(45);
        make.top.equalTo(self.evaluateLabel.mas_bottom).offset(15);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.bg addSubview:self.keywordsView];
    [self.keywordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(15);
        make.right.equalTo(self.bg.mas_right).offset(-15);
        make.top.equalTo(self.evaluateView.mas_bottom).offset(0);
    }];
    
    [self.keywordsView addSubview:self.keywordsTitleLabel];
    [self.keywordsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keywordsView.mas_left).offset(10);
        make.top.equalTo(self.keywordsView.mas_top).offset(12);
    }];
    
    [self.keywordsView addSubview:self.keywordsValueLabel];
    [self.keywordsValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keywordsTitleLabel.mas_right).offset(10);
        make.top.equalTo(self.keywordsView.mas_top).offset(12);
    }];
    
    [self.keywordsView addSubview:self.keywordsLabel];
    [self.keywordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keywordsView.mas_left).offset(10);
        make.right.equalTo(self.keywordsView.mas_right).offset(-10);
        make.top.equalTo(self.keywordsTitleLabel.mas_bottom).offset(6);
        make.bottom.equalTo(self.keywordsView.mas_bottom).offset(-12);
    }];
    
    [self.bg addSubview:self.formulationView];
    [self.formulationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keywordsView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.bg addSubview:self.contentPView];
    [self.contentPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.formulationView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.bg addSubview:self.coherentView];
    [self.coherentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentPView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.bg addSubview:self.logicView];
    [self.logicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coherentView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.bg addSubview:self.affineView];
    [self.affineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logicView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.bg addSubview:self.activelyView];
    [self.activelyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.affineView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    [self.bg addSubview:self.politenessView];
    [self.politenessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activelyView.mas_bottom).offset(10);
        make.left.equalTo(self.bg.mas_left);
        make.right.equalTo(self.bg.mas_right);
        make.height.mas_equalTo(80);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-20);
    }];
    
}

-(void)evaluateUpButtonEvent{
    [self.evaluateUpButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_evaluat_up_pre"] forState:UIControlStateNormal];
    [self.evaluateDownButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_evaluat_down_nor"] forState:UIControlStateNormal];
}

-(void)evaluateDownButtonEvent{
    [self.evaluateUpButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_evaluat_up_nor"] forState:UIControlStateNormal];
    [self.evaluateDownButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_evaluat_down_pre"] forState:UIControlStateNormal];
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

-(UILabel *)analyzeTitleLabel{
    if (!_analyzeTitleLabel) {
        _analyzeTitleLabel = [[UILabel alloc] init];
        _analyzeTitleLabel.textColor = HEXCOLOR(0x333333);
        _analyzeTitleLabel.font = FONT_SYS_MEDIUM(15);
        _analyzeTitleLabel.text = @"答题分析";
    }
    return _analyzeTitleLabel;
}

-(UIButton *)analyzeDescButton{
    if (!_analyzeDescButton) {
        _analyzeDescButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_analyzeDescButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_icon_desc_tag"] forState:UIControlStateNormal];
    }
    return _analyzeDescButton;
}

-(UIView *)evaluateView{
    if (!_evaluateView) {
        _evaluateView = [[UIView alloc] init];
        _evaluateView.backgroundColor = [UIColor clearColor];
    }
    return _evaluateView;
}

-(UILabel *)evaluateLabel{
    if (!_evaluateLabel) {
        _evaluateLabel = [[UILabel alloc] init];
        _evaluateLabel.text = @"请对分析结果进行评分";
        _evaluateLabel.textColor = HEXCOLOR(0x333333);
        _evaluateLabel.font  = FONT_SYS_NOR(14);
    }
    return _evaluateLabel;
}

-(UIButton *)evaluateUpButton{
    if (!_evaluateUpButton) {
        _evaluateUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_evaluateUpButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_evaluat_up_nor"] forState:UIControlStateNormal];
        [_evaluateUpButton addTarget:self action:@selector(evaluateUpButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluateUpButton;
}

-(UIButton *)evaluateDownButton{
    if (!_evaluateDownButton) {
        _evaluateDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_evaluateDownButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_evaluat_down_nor"] forState:UIControlStateNormal];
        [_evaluateDownButton addTarget:self action:@selector(evaluateDownButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluateDownButton;
}

-(UIView *)keywordsView{
    if (!_keywordsView) {
        _keywordsView = [[UIView alloc] init];
        _keywordsView.backgroundColor = HEXCOLOR(0xF6FAFD);
        _keywordsView.layer.cornerRadius = 5;
        _keywordsView.clipsToBounds = YES;
    }
    return _keywordsView;
}

-(UILabel *)keywordsTitleLabel{
    if (!_keywordsTitleLabel) {
        _keywordsTitleLabel = [[UILabel alloc] init];
        _keywordsTitleLabel.text = @"关键词";
        _keywordsTitleLabel.font = FONT_SYS_NOR(14);
        _keywordsTitleLabel.textColor = HEXCOLOR(0x333333);
    }
    return _keywordsTitleLabel;
}

-(UILabel *)keywordsValueLabel{
    if (!_keywordsValueLabel) {
        _keywordsValueLabel = [[UILabel alloc] init];
        _keywordsValueLabel.font = FONT_SYS_NOR(14);
        _keywordsValueLabel.textColor = HEXCOLOR(0x333333);
    }
    return _keywordsValueLabel;
}

-(UILabel *)keywordsLabel{
    if (!_keywordsLabel) {
        _keywordsLabel = [[UILabel alloc] init];
        _keywordsLabel.font = FONT_SYS_NOR(14);
        _keywordsLabel.textColor = HEXCOLOR(0x666666);
        _keywordsLabel.numberOfLines = 0;
    }
    return _keywordsLabel;
}

-(SBAIPracticeProgressView *)formulationView{
    if (!_formulationView) {
        _formulationView = [[SBAIPracticeProgressView alloc] init];
    }
    return _formulationView;
}
-(SBAIPracticeProgressView *)contentPView{
    if (!_contentPView) {
        _contentPView = [[SBAIPracticeProgressView alloc] init];
    }
    return _contentPView;
}
-(SBAIPracticeProgressView *)logicView{
    if (!_logicView) {
        _logicView = [[SBAIPracticeProgressView alloc] init];
    }
    return _logicView;
}
-(SBAIPracticeProgressView *)coherentView{
    if (!_coherentView) {
        _coherentView = [[SBAIPracticeProgressView alloc] init];
    }
    return _coherentView;
}
-(SBAIPracticeProgressView *)affineView{
    if (!_affineView) {
        _affineView = [[SBAIPracticeProgressView alloc] init];
    }
    return _affineView;
}
-(SBAIPracticeProgressView *)activelyView{
    if (!_activelyView) {
        _activelyView = [[SBAIPracticeProgressView alloc] init];
    }
    return _activelyView;
}
-(SBAIPracticeProgressView *)politenessView{
    if (!_politenessView) {
        _politenessView = [[SBAIPracticeProgressView alloc] init];
    }
    return _politenessView;
}

@end
