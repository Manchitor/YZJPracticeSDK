//
//  SBAIPracticeIntroduceViewController.m
//  SBAIPractice
//
//  Created by 刘永吉 on 2023/7/10.
//

#import "SBAIPracticeIntroduceViewController.h"
#import "SBAIPracticeDetailViewController.h"
#import "SBPracticeDownLoadProgressButton.h"
#import "SBAIPracticeRecordMainViewController.h"

#import "SBAIPracticeRequest.h"
#import "SBAIPracticeModel.h"
#import "SBAIPractice.h"

typedef void (^DownloadProgressBlock)(CGFloat progress);

@interface SBAIPracticeIntroduceViewController ()

@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *avatar;

@property (nonatomic,strong) UIView *bg;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIView *positionView;
@property (nonatomic,strong) UILabel *positionLabel;

@property (nonatomic,strong) UIButton *testButton;
@property (nonatomic,strong) UIButton *praceticeButton;
@property (nonatomic,strong) SBPracticeDownLoadProgressButton *downloadButton;
@property (nonatomic,strong) UIView *practiceView;


@property (nonatomic,strong) UILabel *qualifiedTitleLabel;
@property (nonatomic,strong) UILabel *qualifiedLabel;

@property (nonatomic,strong) UILabel *faceTitleLabel;
@property (nonatomic,strong) UILabel *faceLabel;


@property (nonatomic,strong) UILabel *trainTitleLabel;
@property (nonatomic,strong) UILabel *trainLabel;


@property (nonatomic,strong) UILabel *examineTitleLabel;
@property (nonatomic,strong) UILabel *examineLabel;


@property (nonatomic,strong) UILabel *bestLabel;

@property (nonatomic,strong) UIButton *recordButton;

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
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
        make.height.mas_equalTo(250);
    }];
    
    [self.view addSubview:self.bg];
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(415);
    }];
    
    [self.view addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
    }];
    
    [self.bg addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bg);
        make.top.equalTo(self.bg.mas_top).offset(55);
    }];
    
    [self.bg addSubview:self.positionView];
    [self.positionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bg);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(16);
    }];
    
    [self.positionView addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.positionView);
    }];
    
    [self.bg addSubview:self.practiceView];
    [self.practiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(0);
        make.right.equalTo(self.bg.mas_right).offset(0);
        make.top.equalTo(self.positionView.mas_bottom).offset(40);
        make.height.mas_equalTo(100);
    }];
    
    //合格
    [self.practiceView addSubview:self.qualifiedLabel];
    [self.qualifiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.practiceView.mas_centerX).offset(-36);
        make.top.equalTo(self.practiceView.mas_top).offset(0);
    }];
    
    [self.practiceView addSubview:self.qualifiedTitleLabel];
    [self.qualifiedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qualifiedLabel.mas_left).offset(0);
        make.top.equalTo(self.practiceView.mas_top).offset(0);
    }];
    
    //人脸
    [self.practiceView addSubview:self.faceLabel];
    [self.faceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.practiceView.mas_centerX).offset(-36);
        make.top.equalTo(self.qualifiedLabel.mas_bottom).offset(10);
    }];
    
    [self.practiceView addSubview:self.faceTitleLabel];
    [self.faceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qualifiedLabel.mas_left).offset(0);
        make.top.equalTo(self.qualifiedTitleLabel.mas_bottom).offset(10);
    }];
    
    //训练
    [self.practiceView addSubview:self.trainTitleLabel];
    [self.trainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.practiceView.mas_centerX).offset(36);
        make.top.equalTo(self.practiceView.mas_top).offset(0);
    }];
    
    [self.practiceView addSubview:self.trainLabel];
    [self.trainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trainTitleLabel.mas_right).offset(0);
        make.top.equalTo(self.practiceView.mas_top).offset(0);
    }];
    
    //考核
    [self.practiceView addSubview:self.examineTitleLabel];
    [self.examineTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.practiceView.mas_centerX).offset(36);
        make.top.equalTo(self.trainTitleLabel.mas_bottom).offset(10);
    }];
    
    [self.practiceView addSubview:self.examineLabel];
    [self.examineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.examineTitleLabel.mas_right).offset(0);
        make.top.equalTo(self.trainLabel.mas_bottom).offset(10);
    }];
   
    
    [self.bg addSubview:self.downloadButton];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_left).offset(50);
        make.right.equalTo(self.bg.mas_right).offset(-50);
        make.bottom.equalTo(self.bg.mas_bottom).offset(-30);
        make.height.mas_equalTo(42);
    }];
    
    [self.bg addSubview:self.testButton];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bg.mas_centerX).offset(-80);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(42);
        make.top.equalTo(self.downloadButton.mas_top);
    }];
    
    [self.bg addSubview:self.praceticeButton];
    [self.praceticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bg.mas_centerX).offset(80);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(42);
        make.top.equalTo(self.downloadButton.mas_top);
    }];
    
    [self.bg addSubview:self.bestLabel];
    [self.bestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bg.mas_centerX).offset(-20);
        make.bottom.equalTo(self.downloadButton.mas_top).offset(-35);
    }];
    
    [self.bg addSubview:self.recordButton];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bg.mas_centerX).offset(20);
        make.centerY.equalTo(self.bestLabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
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
    
    self.qualifiedLabel.text = [NSString stringWithFormat:@"%@",self.dataModel.passMark >= 0 ? [NSString stringWithFormat:@"%ld",self.dataModel.passMark] :@"-"];
    
    if (self.dataModel.stageType == 0) {//训练
        self.trainTitleLabel.text = @"训练合格：";
        self.trainLabel.text = [NSString stringWithFormat:@"%ld/%ld次",self.dataModel.exerciseStaffCount,self.dataModel.trainingNumber];
        self.examineTitleLabel.hidden = YES;
        self.examineLabel.hidden = YES;
    }else  if (self.dataModel.stageType == 1) {//考核
        self.trainTitleLabel.text = @"考核机会：";
        self.trainLabel.text = [NSString stringWithFormat:@"%ld/%ld次",self.dataModel.examineStaffCount,self.dataModel.examineStaffCount];
        self.examineTitleLabel.hidden = YES;
        self.examineLabel.hidden = YES;
    }else  if (self.dataModel.stageType == 2) {//考核+训练
        self.examineTitleLabel.hidden = NO;
        self.examineLabel.hidden = NO;
        self.trainTitleLabel.text = @"训练合格：";
        self.trainLabel.text = [NSString stringWithFormat:@"%ld/%ld次",self.dataModel.exerciseStaffCount,self.dataModel.trainingNumber];
        
        self.examineTitleLabel.text = @"考核机会：";
        self.examineLabel.text = [NSString stringWithFormat:@"%ld/%ld次",self.dataModel.examineStaffCount,self.dataModel.examineStaffCount];
    }
    
    self.bestLabel.text = [NSString stringWithFormat:@"最佳成绩：%ld",self.dataModel.hsRecordScore];
    
    if (!tf_isEmptyString(path)) {//已下载
        
        self.practiceView.hidden = NO;
        self.bestLabel.hidden = NO;
        self.recordButton.hidden = NO;
        
        if (self.dataModel.stageType == 0) {//训练
            self.testButton.hidden = NO;
            self.praceticeButton.hidden = YES;
            [self.testButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.practiceView.mas_centerX);
            }];
        }else if (self.dataModel.stageType == 1) {//考核
            self.testButton.hidden = YES;
            self.praceticeButton.hidden = NO;
            [self.praceticeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.practiceView.mas_centerX);
            }];
        }else if (self.dataModel.stageType == 2) {//考核+训练
            self.testButton.hidden = NO;
            self.praceticeButton.hidden = NO;
            [self.testButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.practiceView.mas_centerX).offset(-80);
            }];
            [self.praceticeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.practiceView.mas_centerX).offset(80);
            }];
        }
    }else{
        self.testButton.hidden = YES;
        self.praceticeButton.hidden = YES;
        self.practiceView.hidden = YES;
        self.bestLabel.hidden = YES;
        self.recordButton.hidden = YES;
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

-(void)recordButtonEvent{
    SBAIPracticeRecordMainViewController *vc = [[SBAIPracticeRecordMainViewController alloc] init];
    vc.navigationItem.title = self.dataModel.exerciseName;
    vc.exerciseId = self.exerciseId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---------懒加载页面组件
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
        _bgImg.backgroundColor = [UIColor whiteColor];
        _bgImg.image = [UIImage sb_imageNamedFromMyBundle:@"sb_ai_introduce_bg"];
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

-(UIView *)bg{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor whiteColor];
        _bg.layer.cornerRadius = 8;
        _bg.clipsToBounds = YES;
    }
    return _bg;
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
        _positionView.backgroundColor = HEXCOLOR(0xF5FBFF);
    }
    return _positionView;
}

-(UILabel *)positionLabel{
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = HEXCOLOR(0x4A7BAF);
        _positionLabel.font = FONT_SYS_NOR(14);
    }
    return _positionLabel;
}

-(SBPracticeDownLoadProgressButton *)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [SBPracticeDownLoadProgressButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton setTitle:@"下载资源" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downloadButton.layer.cornerRadius = 21;
        _downloadButton.backgroundColor = [UIColor gradientColorWithSize:CGSizeMake(SCREEN_WIDTH - 30 - 100, 42) direction:GradientColorDirectionLevel startColor:HEXCOLOR(0x449EFF) endColor:HEXCOLOR(0x58BFFF)];
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

-(UILabel *)qualifiedTitleLabel{
    if (!_qualifiedTitleLabel) {
        _qualifiedTitleLabel = [[UILabel alloc] init];
        _qualifiedTitleLabel.textColor = HEXCOLOR(0x999999);
        _qualifiedTitleLabel.font = FONT_SYS_NOR(14);
        _qualifiedTitleLabel.text = @"合格分数：";
    }
    return _qualifiedTitleLabel;
}

-(UILabel *)qualifiedLabel{
    if (!_qualifiedLabel) {
        _qualifiedLabel = [[UILabel alloc] init];
        _qualifiedLabel.textColor = HEXCOLOR(0x333333);
        _qualifiedLabel.font = FONT_SYS_NOR(14);
    }
    return _qualifiedLabel;
}

-(UILabel *)faceTitleLabel{
    if (!_faceTitleLabel) {
        _faceTitleLabel = [[UILabel alloc] init];
        _faceTitleLabel.textColor = HEXCOLOR(0x999999);
        _faceTitleLabel.font = FONT_SYS_NOR(14);
        _faceTitleLabel.text = @"人脸监学：";
    }
    return _faceTitleLabel;
}

-(UILabel *)faceLabel{
    if (!_faceLabel) {
        _faceLabel = [[UILabel alloc] init];
        _faceLabel.textColor = HEXCOLOR(0x333333);
        _faceLabel.font = FONT_SYS_NOR(14);
    }
    return _faceLabel;
}

-(UILabel *)trainTitleLabel{
    if (!_trainTitleLabel) {
        _trainTitleLabel = [[UILabel alloc] init];
        _trainTitleLabel.textColor = HEXCOLOR(0x999999);
        _trainTitleLabel.font = FONT_SYS_NOR(14);
    }
    return _trainTitleLabel;
}

-(UILabel *)trainLabel{
    if (!_trainLabel) {
        _trainLabel = [[UILabel alloc] init];
        _trainLabel.textColor = HEXCOLOR(0x333333);
        _trainLabel.font = FONT_SYS_NOR(14);
    }
    return _trainLabel;
}

-(UILabel *)examineTitleLabel{
    if (!_examineTitleLabel) {
        _examineTitleLabel = [[UILabel alloc] init];
        _examineTitleLabel.textColor = HEXCOLOR(0x999999);
        _examineTitleLabel.font = FONT_SYS_NOR(14);
    }
    return _examineTitleLabel;
}

-(UILabel *)examineLabel{
    if (!_examineLabel) {
        _examineLabel = [[UILabel alloc] init];
        _examineLabel.textColor = HEXCOLOR(0x333333);
        _examineLabel.font = FONT_SYS_NOR(14);
    }
    return _examineLabel;
}

-(UILabel *)bestLabel{
    if (!_bestLabel) {
        _bestLabel = [[UILabel alloc] init];
        _bestLabel.textColor = HEXCOLOR(0x333333);
        _bestLabel.font = FONT_SYS_NOR(14);
    }
    return _bestLabel;
}


-(UIButton *)recordButton{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.backgroundColor = [UIColor clearColor];
        [_recordButton setTitle:@"查看记录" forState:UIControlStateNormal];
        [_recordButton setTitleColor:HEXCOLOR(0x3083D9) forState:UIControlStateNormal];
        _recordButton.titleLabel.font = FONT_SYS_NOR(14);
        [_recordButton addTarget:self action:@selector(recordButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

@end
