//
//  SBAIPracticeIntroduceViewController.m
//  SBAIPractice
//
//  Created by 刘永吉 on 2023/7/10.
//

#import "SBAIPracticeIntroduceViewController.h"
#import "SBAIPracticeDetailViewController.h"
#import "SBPracticeDownLoadProgressButton.h"
#import "SBAIPracticeRequest.h"
#import "SBAIPracticeModel.h"
#import "SBAIPractice.h"

typedef void (^DownloadProgressBlock)(CGFloat progress);

@interface SBAIPracticeIntroduceViewController ()

@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIView *positionView;
@property (nonatomic,strong) UILabel *positionLabel;

@property (nonatomic,strong) UIButton *testButton;
@property (nonatomic,strong) UIButton *praceticeButton;
@property (nonatomic,strong) SBPracticeDownLoadProgressButton *downloadButton;
@property (nonatomic,strong) UIView *practiceView;

@property (nonatomic,strong) UILabel *qualifiedScoreLabel;
@property (nonatomic,strong) UILabel *practiceCountLabel;
@property (nonatomic,strong) UILabel *bestScoreLabel;
@property (nonatomic,strong) UILabel *qualifiedCountLabel;

@property (nonatomic,strong) SBAIPracticeModel *dataModel;

//进度
@property (nonatomic,assign) CGFloat speakSchedule;
@property (nonatomic,assign) CGFloat waitSchedule;
@property (nonatomic,assign) CGFloat passSchedule;
@property (nonatomic,assign) CGFloat unpassSchedule;

@end

@implementation SBAIPracticeIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupui];
    [self loaddata];
}

-(void)setupui{
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    
    [self.view addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(50);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(-20);
    }];
    
    [self.view addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.bgImg.mas_top).offset(-40);
    }];
    
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.avatar.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.positionView];
    [self.positionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(16);
    }];
    
    [self.positionView addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.positionView);
    }];
    
    [self.view addSubview:self.downloadButton];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-60);
        make.bottom.equalTo(self.bgImg.mas_bottom).offset(-120);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.testButton];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-90);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.downloadButton.mas_top);
    }];
    
    [self.view addSubview:self.praceticeButton];
    [self.praceticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(90);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.downloadButton.mas_top);
    }];
    
    [self.view addSubview:self.practiceView];
    [self.practiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.bgImg.mas_bottom).offset(-20);
        make.height.mas_equalTo(100);
    }];
    
    [self.practiceView addSubview:self.qualifiedScoreLabel];
    [self.qualifiedScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.practiceView.mas_left).offset(15);
        make.top.equalTo(self.practiceView.mas_top).offset(15);
    }];
    
    [self.practiceView addSubview:self.bestScoreLabel];
    [self.bestScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.qualifiedScoreLabel.mas_left);
        make.top.equalTo(self.qualifiedScoreLabel.mas_bottom).offset(15);
    }];
    
    [self.practiceView addSubview:self.qualifiedCountLabel];
    [self.qualifiedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.practiceView.mas_right).offset(-15);
        make.top.equalTo(self.practiceView.mas_top).offset(15);
    }];
    
    [self.practiceView addSubview:self.practiceCountLabel];
    [self.practiceCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qualifiedCountLabel.mas_right);
        make.top.equalTo(self.qualifiedCountLabel.mas_bottom).offset(15);
    }];
}

-(void)loaddata{
    
    MJWeakSelf;
    [MBProgressHUD showHUD];
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.exerciseId forKey:@"exerciseId"];
    [params setObject:loginModel.userId forKey:@"userId"];

    [SBAIPracticeRequest sb_exerciseDetailScoreRequest:params Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        [MBProgressHUD hideHUD];
        if (isSuccess) {
            weakSelf.dataModel = [SBAIPracticeModel mj_objectWithKeyValues:responseObject.data];
            [weakSelf setupdata];

        }else{
            tf_toastMsg(responseObject.msg);
        }
    }];
}

-(void)setupdata{
    
    self.navigationItem.title = self.dataModel.exerciseName;
    
    //1.缓存目录 带时间 带文件ur的md5 .mp4
    NSString *filename = [NSString stringWithFormat:@"%@.mp4",[SBAITool SB_MD5:self.dataModel.speakVideo]];//url md5为参数
     
    NSString *path = [SBFileTool fileItemInCacheDirectory:filename];
    //判断是否已缓存资目录
    self.downloadButton.hidden = !tf_isEmptyString(path);

    [self.avatar sd_setImageWithURL:self.dataModel.headerImg.toURL placeholderImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_avatar_default"]];
    
    self.nameLabel.text = tf_isEmptyString(self.dataModel.robotName) ? @"" : self.dataModel.robotName;
    
    self.positionLabel.text = tf_isEmptyString(self.dataModel.robotCareer) ? @"" : self.dataModel.robotCareer;
    
    self.qualifiedScoreLabel.text = [NSString stringWithFormat:@"合格分数：%@",self.dataModel.passMark >= 0 ? [NSString stringWithFormat:@"%ld",self.dataModel.passMark] :@"-"];
    
    self.bestScoreLabel.text = [NSString stringWithFormat:@"最佳成绩：%@",self.dataModel.hsRecordScore >= 0 ? [NSString stringWithFormat:@"%ld",self.dataModel.hsRecordScore] :@"-"];
    
    if (self.dataModel.stageType == 0) {//训练
        self.qualifiedCountLabel.text = [NSString stringWithFormat:@"训练合格：%ld/%ld次",self.dataModel.examineStaffCount,self.dataModel.examineNumber];
        self.practiceCountLabel.hidden = YES;
    }else  if (self.dataModel.stageType == 1) {//考核
        self.qualifiedCountLabel.text = [NSString stringWithFormat:@"考核合格：%ld/%ld次",self.dataModel.examineStaffCount,self.dataModel.examineNumber];
    }else  if (self.dataModel.stageType == 2) {//考核+训练
        self.qualifiedCountLabel.text = [NSString stringWithFormat:@"训练合格：%ld/%ld次",self.dataModel.exerciseStaffCount,self.dataModel.examineNumber];
        
        self.practiceCountLabel.text = [NSString stringWithFormat:@"考核合格：%ld/%ld次",self.dataModel.examineStaffCount,self.dataModel.examineNumber];
    }
    
    
    if (!tf_isEmptyString(path)) {//已下载
        if (self.dataModel.stageType == 0) {//训练
            self.testButton.hidden = NO;
            self.praceticeButton.hidden = YES;
            [self.testButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
            }];
        }else if (self.dataModel.stageType == 1) {//考核
            self.testButton.hidden = YES;
            self.praceticeButton.hidden = NO;
            [self.praceticeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
            }];
        }else if (self.dataModel.stageType == 2) {//考核+训练
            self.testButton.hidden = NO;
            self.praceticeButton.hidden = NO;
            [self.testButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(-90);
            }];
            [self.praceticeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(90);
            }];
        }
    }else{
        self.testButton.hidden = YES;
        self.praceticeButton.hidden = YES;
    }
}

- (void)downloadButtonEvent {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    MJWeakSelf;
    [self downloadUrl:self.dataModel.speakVideo Group:group queue:queue preogress:^(CGFloat progress) {
        weakSelf.speakSchedule = progress;
        [weakSelf calculateProgress];
    }];
    [self downloadUrl:self.dataModel.waitVideo Group:group queue:queue preogress:^(CGFloat progress) {
        weakSelf.waitSchedule = progress;
        [weakSelf calculateProgress];
    }];
    [self downloadUrl:self.dataModel.passVideo Group:group queue:queue preogress:^(CGFloat progress) {
        weakSelf.passSchedule = progress;
        [weakSelf calculateProgress];
    }];
    [self downloadUrl:self.dataModel.unPassVideo Group:group queue:queue preogress:^(CGFloat progress) {
        weakSelf.unpassSchedule = progress;
        [weakSelf calculateProgress];
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"下载完成");
        [self.downloadButton setTitle:@"下载完成" forState:UIControlStateNormal];
        [self setupdata];
    });
}

#pragma mark ---------下载资源
-(void)downloadUrl:(NSString *)url Group:(dispatch_group_t)group
             queue:(dispatch_queue_t)queue preogress:(DownloadProgressBlock )progress{
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [RequestManager DownloadVideoWithUrl:url parameters:nil timeoutInterval:100 progress:^(NSProgress *downloadProgress) {
            CGFloat schedule = 1.0 *downloadProgress.completedUnitCount /downloadProgress.totalUnitCount;
            if (progress){
                progress(schedule);
            }
        } response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
            dispatch_group_leave(group);
        }];
    });
}


-(void)calculateProgress{
    CGFloat schedule = self.speakSchedule *0.25 + self.waitSchedule *0.25 + self.passSchedule *0.25 + self.unpassSchedule *0.25;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadButton.progress = schedule;
        [self.downloadButton setTitle:[NSString stringWithFormat:@"下载中%.0f%%",schedule*100] forState:UIControlStateNormal];
    });
    NSLog(@"下载总进度:%f",schedule);
}


-(void)testButtonEvent{
    SBAIPracticeDetailViewController *vc = [[SBAIPracticeDetailViewController alloc] init];
    vc.isHidenNavigationBar = YES;
    vc.dataModel = self.dataModel;
    vc.stageType = SBAIPracticeStageTypeExercise;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)practiceButtonEvent{
    SBAIPracticeDetailViewController *vc = [[SBAIPracticeDetailViewController alloc] init];
    vc.isHidenNavigationBar = YES;
    vc.dataModel = self.dataModel;
    vc.stageType = SBAIPracticeStageTypeExamine;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---------懒加载页面组件
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
        _bgImg.backgroundColor = [UIColor whiteColor];
        _bgImg.layer.cornerRadius = 8;
        _bgImg.clipsToBounds = YES;
    }
    return _bgImg;
}

-(UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 40;
        _avatar.clipsToBounds = YES;
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        _avatar.layer.borderWidth  = 8;
        _avatar.layer.borderColor = HEXCOLOR(0xF8F8F8).CGColor;
    }
    return _avatar;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.font = FONT_SYS_NOR(16);
    }
    return _nameLabel;
}

-(UIView *)positionView{
    if (!_positionView) {
        _positionView = [[UIView alloc] init];
        _positionView.layer.cornerRadius = 8;
        _positionView.clipsToBounds = YES;
        _positionView.backgroundColor = HEXCOLOR(0x52A0FF);
    }
    return _positionView;
}

-(UILabel *)positionLabel{
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = [UIColor whiteColor];
        _positionLabel.font = FONT_SYS_NOR(14);
    }
    return _positionLabel;
}

-(SBPracticeDownLoadProgressButton *)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [SBPracticeDownLoadProgressButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton setTitle:@"下载资源" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downloadButton.layer.cornerRadius = 20;
        _downloadButton.backgroundColor = HEXCOLOR(0x52A0FF);
        _downloadButton.clipsToBounds = YES;
        _downloadButton.hidden = YES;
        [_downloadButton addTarget:self action:@selector(downloadButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

-(UIButton *)testButton{
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"训练" forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _testButton.layer.cornerRadius = 20;
        _testButton.backgroundColor = HEXCOLOR(0x52A0FF);
        _testButton.clipsToBounds = YES;
        _testButton.hidden = YES;
        [_testButton addTarget:self action:@selector(testButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

-(UIButton *)praceticeButton{
    if (!_praceticeButton) {
        _praceticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praceticeButton setTitle:@"考核" forState:UIControlStateNormal];
        [_praceticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _praceticeButton.layer.cornerRadius = 20;
        _praceticeButton.backgroundColor = HEXCOLOR(0x52A0FF);
        _praceticeButton.clipsToBounds = YES;
        _praceticeButton.hidden = YES;
        [_praceticeButton addTarget:self action:@selector(practiceButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praceticeButton;
}

-(UIView *)practiceView{
    if (!_practiceView) {
        _practiceView = [[UIView alloc] init];
        _practiceView.backgroundColor = [UIColor clearColor];
    }
    return _practiceView;
}

-(UILabel *)qualifiedScoreLabel{
    if (!_qualifiedScoreLabel) {
        _qualifiedScoreLabel = [[UILabel alloc] init];
        _qualifiedScoreLabel.textColor = HEXCOLOR(0x333333);
        _qualifiedScoreLabel.font = FONT_SYS_NOR(15);
    }
    return _qualifiedScoreLabel;
}
-(UILabel *)bestScoreLabel{
    if (!_bestScoreLabel) {
        _bestScoreLabel = [[UILabel alloc] init];
        _bestScoreLabel.textColor = HEXCOLOR(0x333333);
        _bestScoreLabel.font = FONT_SYS_NOR(15);
    }
    return _bestScoreLabel;
}
-(UILabel *)qualifiedCountLabel{
    if (!_qualifiedCountLabel) {
        _qualifiedCountLabel = [[UILabel alloc] init];
        _qualifiedCountLabel.textColor = HEXCOLOR(0x333333);
        _qualifiedCountLabel.font = FONT_SYS_NOR(15);
    }
    return _qualifiedCountLabel;
}
-(UILabel *)practiceCountLabel{
    if (!_practiceCountLabel) {
        _practiceCountLabel = [[UILabel alloc] init];
        _practiceCountLabel.textColor = HEXCOLOR(0x333333);
        _practiceCountLabel.font = FONT_SYS_NOR(15);
    }
    return _practiceCountLabel;
}
@end
