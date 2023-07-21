//
//  SBAIPracticeAnalyseViewController.m
//  SBAIPractice
//
//  Created by 刘永吉 on 2023/6/29.
//

#import "SBAIPracticeAnalyseViewController.h"

#import "SBAIPracticeRequest.h"
#import "SBAIPracticeAnalyzeModel.h"

#import "SBAIPracticeAnalyseScoreView.h"
#import "SBAIPracticeAnalysAnswerView.h"
#import "SBAIPracticeAnalysExpressionView.h"
#import "SBAIPracticeAnslyseReviewView.h"

#import "SBAIPracticeResultViewController.h"
#import "SBAIPractice.h"

@interface SBAIPracticeAnalyseViewController ()
@property (nonatomic,strong) UIScrollView *scro;
@property (nonatomic,strong) SBAIPracticeAnalyseScoreView *scoreView;
@property (nonatomic,strong) SBAIPracticeAnalysAnswerView *answerRadarView;
@property (nonatomic,strong) SBAIPracticeAnalysExpressionView *expressionRadarView;
@property (nonatomic,strong) SBAIPracticeAnslyseReviewView *answerReviewView;
@property (nonatomic,strong) UIButton *againButton;

@property (nonatomic,strong) SBAIPracticeAnalyzeModel *dataModel;

@end

@implementation SBAIPracticeAnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupconfig];
    [self setupui];
    [self loaddata];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.expressionRadarView.isfinish = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.expressionRadarView.isfinish = YES;
}

-(void)setupconfig{
    self.navigationItem.title = @"答题分析";
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

#pragma mark ----------初始化页面UI
-(void)setupui{
    [self.view addSubview:self.scro];
    [self.scro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    CGFloat height = 110/375.0*SCREEN_WIDTH;
    [self.scro addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scro);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.scro addSubview:self.answerRadarView];
    [self.answerRadarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreView.mas_bottom);
        make.left.equalTo(self.scro);
        make.height.mas_equalTo(370);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.scro addSubview:self.expressionRadarView];
    [self.expressionRadarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerRadarView.mas_bottom);
        make.left.equalTo(self.scro);
        make.height.mas_equalTo(475);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.scro addSubview:self.answerReviewView];
    [self.answerReviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressionRadarView.mas_bottom);
        make.left.equalTo(self.scro);
        make.height.mas_equalTo(68*5 + 47 + 24 + 12 + 12);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.scro addSubview:self.againButton];
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerReviewView.mas_bottom).offset(95);
        make.left.equalTo(self.scro).offset(65);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(SCREEN_WIDTH - 130);
        make.bottom.equalTo(self.scro.mas_bottom).offset(-24);
    }];
    
}

-(void)loaddata{
    MJWeakSelf;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.Id forKey:@"id"];
    [SBAIPracticeRequest sb_exerciseAnalyzeRequest:params Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (isSuccess){
            weakSelf.dataModel = [SBAIPracticeAnalyzeModel mj_objectWithKeyValues:responseObject.data];
            [weakSelf reloadData];
        }else{
            tf_toastMsg(responseObject.msg);
        }
    }];
}

-(void)reloadData{
    self.scoreView.model = self.dataModel;
    self.answerRadarView.model = self.dataModel;
    self.expressionRadarView.model = self.dataModel;
    
    
    [self.answerReviewView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(68*self.dataModel.staffEntities.count + 47 + 24 + 12 + 12);
    }];
    self.answerReviewView.model = self.dataModel;
    
    if (!self.dataModel.supervision){
        [self.expressionRadarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.expressionRadarView.hidden = YES;
    }else{
        [self.expressionRadarView startAnimation];
    }
}

-(void)againButtonEvent{
    [self backController];
}

-(void)backController{
    BOOL isHas = NO;
    
    for(UIViewController*controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:NSClassFromString(@"SBAIPracticeDetailViewController")]) {
            isHas = YES;
            break;
        }
    }
    if (isHas){
        for(UIViewController*controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:NSClassFromString(@"SBAIPracticeIntroduceViewController")]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }else{
        [super backController];
    }
}

-(void)pushPracticeResult:(SBAIPracticeResultModel *)item{
        SBAIPracticeResultViewController *vc = [[SBAIPracticeResultViewController alloc] init];
        vc.dataModel = item;
        [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------懒加载
-(UIScrollView *)scro{
    if (!_scro){
        _scro = [[UIScrollView alloc] init];
        _scro.backgroundColor = HEXCOLOR(0xf9f9f9);
        
    }
    return _scro;
}

-(SBAIPracticeAnalyseScoreView *)scoreView{
    if(!_scoreView){
        _scoreView = [[SBAIPracticeAnalyseScoreView alloc] init];
    }
    return _scoreView;
}

-(SBAIPracticeAnalysAnswerView *)answerRadarView{
    if(!_answerRadarView){
        _answerRadarView = [[SBAIPracticeAnalysAnswerView alloc] init];
    }
    return _answerRadarView;
}

-(SBAIPracticeAnalysExpressionView *)expressionRadarView{
    if(!_expressionRadarView){
        _expressionRadarView = [[SBAIPracticeAnalysExpressionView alloc] init];
    }
    return _expressionRadarView;
}

-(SBAIPracticeAnslyseReviewView *)answerReviewView{
    if(!_answerReviewView){
        _answerReviewView = [[SBAIPracticeAnslyseReviewView alloc] init];
        MJWeakSelf;
        _answerReviewView.itemBlock = ^(SBAIPracticeResultModel * _Nonnull item) {
            [weakSelf pushPracticeResult:item];
        };
    }
    return _answerReviewView;
}

-(UIButton *)againButton{
    if(!_againButton){
        _againButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_againButton setTitle:@"再次练习" forState:UIControlStateNormal];
        [_againButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _againButton.layer.cornerRadius = 21;
        _againButton.clipsToBounds = YES;
        _againButton.backgroundColor = [UIColor gradientColorWithSize:CGSizeMake(SCREEN_WIDTH - 130, 42) direction:GradientColorDirectionLevel startColor:HEXCOLOR(0x449EFF) endColor:HEXCOLOR(0x58BFFF)];
        _againButton.titleLabel.font = FONT_SYS_NOR(16);
        [_againButton addTarget:self action:@selector(againButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againButton;
}

@end
