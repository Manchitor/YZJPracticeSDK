//
//  SBAIPracticeDetailViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/29.
//

#import "SBAIPracticeDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>
#import "SBAIMonitoringViewController.h"
#import "SBAIFaceOcrViewController.h"
#import "SBAIPracticeTextView.h"
#import "SBAIPracticeAlertView.h"
#import "SBAIPracticeRequest.h"
#import "SBAIPracticeAnalyseViewController.h"

@interface SBAIPracticeDetailViewController ()<SFSpeechRecognizerDelegate,AVSpeechSynthesizerDelegate,AVAudioRecorderDelegate,UITextViewDelegate>
///画面layer
@property (nonatomic,strong)AVPlayerLayer   *avlayer;
///视频播放器
@property (nonatomic,strong)AVPlayer    *player;
///语音播放器
@property (nonatomic,strong)AVAudioPlayer   *audioPlayer;
///文字展示定时器
@property (nonatomic,strong) NSTimer    *wordsTimer;
///当前文字展示下标
@property (nonatomic) int   currentIndex;
///对答内容输入框
@property (nonatomic,strong) SBAIPracticeTextView     *textView;
///重新开始
@property (nonatomic,strong) UIButton   *resetButton;
///提交
@property (nonatomic,strong) UIButton   *commitButton;
///录音
@property (nonatomic,strong) UIButton   *recordButton;
/// 语音引擎，负责提供语音输入
@property (nonatomic, strong) AVAudioEngine         *audioEngine;
///语音识别器
@property (nonatomic, strong) SFSpeechRecognizer    *speechRecognizer;
/// 处理语音识别请求
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest     *recognitionRequest;
/// 输出语音识别对象的结果
@property (nonatomic, strong) SFSpeechRecognitionTask   *recognitionTask;
///语言类型
@property (nonatomic, strong) NSLocale                  *locale;
///监学视图
@property (nonatomic,strong) SBAIMonitoringViewController   *monitoringvc;
///人脸表情识别
@property (nonatomic,strong) SBAIFaceOcrViewController  *faceocrvc;
@property (nonatomic,strong) dispatch_source_t  timer;//定时器
///返回按钮
@property (nonatomic,strong) UIButton   *backButton;
//录音
@property (nonatomic, strong) AVAudioRecorder   *recorder;
@property (nonatomic,strong) NSMutableArray *volumeArray;
//提示
@property (nonatomic,strong) SBAIPracticeAlertView *alertView;
///当前问题下标
@property (nonatomic,assign) NSInteger questionIndex;
///当前播放类型
@property (nonatomic,assign) SBAIPracticePlayType playType;
///开始时间
@property (nonatomic,strong) NSDate *startDate;
///录入数组 断点记录
@property (nonatomic,strong) NSMutableArray *recordTextArray;
///结果分展示
@property (nonatomic,strong) UILabel *scoreTotalLabel;

///结果分展示
@property (nonatomic,copy) NSString *uniqueId;
@end

@implementation SBAIPracticeDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupconfig];
    [self setupui];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopallsession];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //首次播放,等待页面显示后开始各个会话
    //1.播放视频
    [self.avlayer.player play];//视频
    //2.播放音频
    [self playaudio];
    //3.开启问题文字滚动
    [self playText];//文字
    //4.设置当前播放状态
    self.playType = SBAIPracticePlayTypeSpeak;
}

#pragma mark ----------停止所有会话
-(void)stopallsession{
    //1.停止音频播放
    [self stopAudio];
    //2.停止问题文字滚动
    [self stopOutputText];
    //3.停止录音
    [self stopRecordAudio];
    //4.停止语音录入
    [self stopRecordSpeech];
    //5.停止人脸识别 监学
    if(self.dataModel.supervision){
        [self stopFaceTime];
    }
    //6.移除视频播放完成监听
    if (self.avlayer.player.currentItem){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avlayer.player.currentItem];
    }
}

#pragma mark ----------初始化页面配置
-(void)setupconfig{
    //1.记录开始时间
    self.startDate = [NSDate date];
    
    //2.默认控件显示
    self.resetButton.hidden = YES;
    self.commitButton.hidden = YES;
    self.recordButton.hidden = YES;
    
    //3.初始化唯一标识符：平台+时间戳+userId
    long timeInterval = (long) ([self.startDate timeIntervalSince1970]*1000);
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];
    
    self.uniqueId = [NSString stringWithFormat:@"iOS_%ld_%@",timeInterval,loginModel.userId];
}

#pragma mark ----------初始化页面UI
-(void)setupui{
    //计算安全区
    UIEdgeInsets edge  = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        edge =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets;
    }
    
    //缓存目录 带时间 带文件ur的md5 .mp4
    NSString *filename = [NSString stringWithFormat:@"%@.mp4",[SBAITool SB_MD5:self.dataModel.speakVideo]];//url md5为参数
    
    NSString *path = [SBFileTool fileItemInCacheDirectory:filename];
    
    //0.创建avlayer 资源 暂不播放
    self.avlayer = [self setupPlayerLayerWithVideoPath:path ? path : self.dataModel.speakVideo];
    
    //1.创建显示视频的AVPlayerLayer,设置视频显示属性，并添加视频图层
    [self.view.layer addSublayer:self.avlayer];
    self.avlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //2.返回按钮
    [self.view addSubview:self.backButton];
    self.backButton.frame = CGRectMake(20, [[UIApplication sharedApplication] statusBarFrame].size.height + 20, 30, 30);
    
    //3.创建对答输入框
    [self.view addSubview:self.textView];
    self.textView.frame = CGRectMake(15, SCREEN_HEIGHT - edge.bottom - 20 - 64 - 25 - 168, SCREEN_WIDTH - 30, 168);
    
    //4.功能按钮
    [self.view addSubview:self.resetButton];
    self.resetButton.frame = CGRectMake(20, CGRectGetMaxY(self.textView.frame) + 34, 46, 46);
    
    [self.view addSubview:self.commitButton];
    self.commitButton.frame = CGRectMake(SCREEN_WIDTH - 20 - 46, CGRectGetMaxY(self.textView.frame) + 34, 46, 46);
    
    [self.view addSubview:self.recordButton];
    self.recordButton.frame = CGRectMake(SCREEN_WIDTH/2.0 - 32, CGRectGetMaxY(self.textView.frame) + 25, 64, 64);
    
    //5.监学模式
    if (self.dataModel.supervision) {
        self.monitoringvc.view.frame = CGRectMake(20, CGRectGetMaxY(self.backButton.frame) + 20, 80, 100);
        [self.view addSubview:self.monitoringvc.view];
    }
    
    //6.人脸表情识别
    if (self.dataModel.supervision) {
        //self.faceocrvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100);//调试frame
        
        self.faceocrvc.view.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0);
        [self.view addSubview:self.faceocrvc.view];
        [self openFaceTime];//开启人脸表情识别定时器
    }
    
    //7.提示view
    if (self.stageType == 0){
        
        //        NSString *alertText = @"CT4专为女性客户打造的柔光化妆镜，它拥有6颗 LED灯，开启时让你的肤色更自然，营造出专展化妆间的感觉； 有了我们专属女性客户打造的柔光化妆镜，您在车内就像一个小仙女。";
        //        NSDictionary *attribute = @{NSFontAttributeName: FONT_SYS_NOR(16)};
        //        CGRect rect = [alertText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, CGFLOAT_MAX)
        //                                              options:NSStringDrawingUsesLineFragmentOrigin
        //                                           attributes:attribute
        //                                              context:nil];
        //        self.alertView.frame = CGRectMake(20, CGRectGetMaxY(self.backButton.frame) + 40, SCREEN_WIDTH - 40, rect.size.height + 20 + 20 + 15 + 15);
        //        self.alertView.alertText = alertText;
        //        [self.view addSubview:self.alertView];
    }
    
    [self.view addSubview:self.scoreTotalLabel];
}

#pragma mark ----------视频
-(AVPlayerLayer *)setupPlayerLayerWithVideoPath:(NSString *)videoPath{
    //0.移除观者
    if (self.avlayer.player.currentItem){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        _player = nil;
    }
    
    //1.创建playitem
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:videoPath]];
    
    //2.创建player
    _player = [AVPlayer playerWithPlayerItem:playItem];
    
    //3.创建player layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    //4.设置player layer 填充模式
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //5.注册观察者，监测播放状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    return layer;
}

//视频播放完成
-(void)itemDidFinishPlaying{
    if (self.playType == SBAIPracticePlayTypeSpeak) {
        //1.显示录入按钮
        self.recordButton.hidden = NO;
        //2.设置录入按钮状态
        self.recordButton.selected = NO;
        //3.切换等待视频
        NSString *filename = [NSString stringWithFormat:@"%@.mp4",[SBAITool SB_MD5:self.dataModel.waitVideo]];
        NSString *path = [SBFileTool fileItemInCacheDirectory:filename];
        //4.初始化视频播放layer
        AVPlayerLayer *layer = [self setupPlayerLayerWithVideoPath:path];
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view.layer insertSublayer:layer above:self.avlayer];
        self.avlayer = layer;
        //5.播放等待视频
        [_player play];
        //6.停止问题描述的音频
        [self.audioPlayer stop];
        //7.设置当前的播放状态
        self.playType = SBAIPracticePlayTypeWait;
        
    }else if (self.playType == SBAIPracticePlayTypeWait) {
        //1.设置等待视频循环播放
        [self.avlayer.player.currentItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            //2.播放
            [self.avlayer.player play];
        }];        
    }else if (self.playType == SBAIPracticePlayTypePass || self.playType == SBAIPracticePlayTypeUnpass) {
        //0.切换问题描述视频
        NSString *filename = [NSString stringWithFormat:@"%@.mp4",[SBAITool SB_MD5:self.dataModel.speakVideo]];
        NSString *path = [SBFileTool fileItemInCacheDirectory:filename];
        //1.初始化视频播放layer
        AVPlayerLayer *layer = [self setupPlayerLayerWithVideoPath:path];
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view.layer insertSublayer:layer above:self.avlayer];
        //2.播放问题描述视频
        self.avlayer = layer;
        [_player play];
        //3.播放音频
        [self playaudio];
        //4.播放问题文字滚动
        [self playText];
        //5.设置当前的播放状态
        self.playType = SBAIPracticePlayTypeSpeak;
    }
}

#pragma mark ----------音频
-(void)playaudio{
    //0.获取当前播放资源
    SBAIPracticeQuestionModel *model = self.dataModel.questionList[self.questionIndex];
    
    if (tf_isEmptyString(model.backgroundImage)) {
        NSLog(@"此问题暂无音频描述！");
        return;
    }
    //1.设置音频会话模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    //2.初始化音频资源
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:model.backgroundImage]];
    //3.初始化音频播放器
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:mydata error:&error];
    if (!error) {
        //4.开启音频播放
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }else{
        NSLog(@"音频初始化失败error:%@",error.localizedDescription);
    }}

-(void)stopAudio{
    //停止音频播放
    [self.audioPlayer stop];
    //置空语音播放器
    self.audioPlayer = nil;
}

#pragma mark ----------问题文字滚动
-(void)playText{
    //1.初始化问题文字滚动定时器-倒计时
    self.wordsTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(outputText) userInfo:nil repeats:YES];
    //2.添加倒计时定时器
    [[NSRunLoop currentRunLoop] addTimer:self.wordsTimer forMode:NSRunLoopCommonModes];
}

-(void)outputText{
    //0.获取数据
    SBAIPracticeQuestionModel *model = self.dataModel.questionList[self.questionIndex];
    //1.数据判断，异常排除
    if (tf_isEmptyString(model.question)) {
        [self stopOutputText];
        return;
    }
    //2.判断问题文字是否滚动完成
    if(model.question.length <= self.currentIndex){
        //3.停止文字滚动
        [self stopOutputText];
    }else{
        //4.增加滚动文字
        self.currentIndex++;
        //5.获取当前需显示的文字内容
        NSString *subText = [model.question substringToIndex:self.currentIndex];
        //6.赋值
        self.textView.text = subText;
        //7.滚动范围至可见
        [self.textView scrollRangeToVisible:NSMakeRange(subText.length, 1)];
    }
}

-(void)stopOutputText{
    //1.重置滚动下标
    self.currentIndex = 0;
    //2.停止定时器
    [self.wordsTimer invalidate];
    //3.定时器置空
    self.wordsTimer = nil;
}

#pragma mark ----------重录
-(void)resetButtonEvent{
    //1.获取数据
    SBAIPracticeQuestionModel *model = self.dataModel.questionList[self.questionIndex];
    //2.展示问题
    self.textView.text = model.question;
    //3.停止语音录入
    [self stopRecordSpeech];
    //4.停止录音
    [self stopRecordAudio];
    //5.清除语音录入历史文字
    [self.recordTextArray removeAllObjects];
    //6.删除音量
    [self.volumeArray removeAllObjects];
}

#pragma mark ----------语音录入相关处理
-(void)recordButtonEvent{
    [self.textView endEditing:YES];
    
    self.recordButton.selected = !self.recordButton.selected;
    if (!self.recordButton.selected) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showHUD];
        
        [self stopRecordSpeech];
        [self pauseRecordAudio];
        return;
    }
    //显示 重制与提交
    self.resetButton.hidden = YES;
    self.commitButton.hidden = YES;
    self.textView.userInteractionEnabled = NO;
    //重新录制或者继续录制展示历史语音录入信息
    NSMutableString *textString = [[NSMutableString alloc] init];
    for (NSString *text in self.recordTextArray) {
        [textString appendString:text];
    }
    [self.textView setText:textString];
    
    //0.设置语音录入按钮图片显示
    [self.recordButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_recording"] forState:UIControlStateNormal];
    
    //1.设置音频会话模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    //2.开启录音或者恢复录音
    [self startRecordAudio];
    //3.构建语音识别录入
    MJWeakSelf;
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        NSString *bestResult = [[result bestTranscription] formattedString];
        isFinal = result.isFinal;
        if (error || isFinal) {
            [MBProgressHUD hideHUD];
            //4.停止录入
            [weakSelf stopRecordSpeech];
            //5.暂停录音
            [weakSelf pauseRecordAudio];
            //6.更新录入文字历史
            [weakSelf.recordTextArray removeAllObjects];
            [weakSelf.recordTextArray addObject:weakSelf.textView.text ? weakSelf.textView.text : @""];
            
            weakSelf.textView.userInteractionEnabled = YES;
            
            //2.设置语音录入按钮状态
            [self.recordButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_record"] forState:UIControlStateNormal];
            
            //3.显示重置与提交
            self.resetButton.hidden = NO;
            self.commitButton.hidden = NO;
            
            //7.结束日志输出
            if (error) {
                NSLog(@"语音录入停止Error:%@",error.localizedDescription);
            }else{
                NSLog(@"语音录入结束。");
            }
        } else {
            //8.文字最优处理
            NSMutableString *textString = [[NSMutableString alloc] init];
            for (NSString *text in self.recordTextArray) {
                [textString appendString:text];
            }
            
            //9.拼接本次语音录入文案
            [weakSelf.textView setText:[NSString stringWithFormat:@"%@%@",textString,bestResult]];
        }
    }];
    
    //10.语音录入Buffer处理
    AVAudioFormat *recordingFormat = [[self.audioEngine inputNode] outputFormatForBus:0];
    [[self.audioEngine inputNode] installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    //11.准备语音录入
    [self.audioEngine prepare];
    
    //12.开启语音录入
    NSError *startError = nil;
    [self.audioEngine startAndReturnError:&startError];
    //13.语音录入开启状态错误处理
    if (startError) {
        NSLog(@"语音录入开启失败Error:%@",startError.localizedDescription);
    }else{
        NSLog(@"语音录入开启成功。");
    }
}

//停止录入
-(void)stopRecordSpeech{
    //1.停止语音录入
    [[self.audioEngine inputNode] removeTapOnBus:0];
    [self.audioEngine stop];
    [self.recognitionRequest endAudio];
    self.recognitionRequest = nil;
    self.recognitionTask = nil;
}


#pragma mark ----------录音
-(void)startRecordAudio{
    //1.判断录音是否已经创建
    if (self.recorder){//
        //2.当前处于录音暂停状态,恢复录音.
        [self.recorder record];
    }else{
        //3.设置音频会话模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        
        //4.获取录音文件目录
        NSString *path = [SBFileTool absolutePath:@"practice_audio_file" filePathType:SBFileToolPathTypeCache];
        //5.删除上一个录音文件
        if ([SBFileTool isfileExistsAtPath:path]){
            [SBFileTool removePath:path];
        }
        //6.创建录音文件路径
        [SBFileTool createPath:path];
        //7.设置录音文件url
        NSString *filePath = [path stringByAppendingPathComponent:@"audio.aac"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        //8.初始化录音settings
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
        //录音通道数  1 或 2
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        //9.初始化录音
        NSError *error;
        self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
        if (!error) {
            //10.设置代理
            self.recorder.delegate = self;
            //11.开启音量检测
            self.recorder.meteringEnabled = YES;
            //12.开启录音
            [self.recorder prepareToRecord];
            [self.recorder record];
        }else{
            NSLog(@"录音组件初始化失败error:%@",error.localizedDescription);
        }
    }
}

-(void)pauseRecordAudio{
    //1.更新音量检测
    [self.recorder updateMeters];
    //2.获取平均音量
    CGFloat avg = [self.recorder averagePowerForChannel:0];
    //比如把-60作为最低分贝
    float minValue = -160;
    //把60作为获取分配的范围
    float range = 60;
    //把100作为输出分贝范围
    float outRange = 100;
    //确保在最小值范围内
    if (avg < minValue){
        avg = minValue;
    }
    //3.计算
    float decibels = (avg + range) / range * outRange;
    //4.音量异常排除
    if (self.recorder.isRecording && decibels > 0){
        [self.volumeArray addObject:@(decibels)];
    }
    //4.暂停录音
    [self.recorder pause];
}

-(void)stopRecordAudio{
    //1.结束录音
    if (self.recorder){
        //2.停止录音后释放掉
        [self.recorder stop];
        //3.重置录音组件
        self.recorder.delegate = nil;
        //4.置空录音组件
        self.recorder = nil;
    }
}

#pragma mark ----------提交
-(void)commitButtonEvent{
    //1.内容判空
    if (!self.textView.text.length || !self.recordTextArray.count) {
        tf_toastMsg(@"回复不能为空");
        return;
    }
    //2.停止录音
    [self stopRecordAudio];
    
    //3.删除历史语音录入文字，以当前输入框内容为全部内容
    [self.recordTextArray removeAllObjects];
    
    //4.构建录音文件上传参数
    SBAIPracticeQuestionModel *model = self.dataModel.questionList[self.questionIndex];
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];
    
    NSMutableDictionary *fileparams = [[NSMutableDictionary alloc] init];
    [fileparams setObject:loginModel.userId forKey:@"userId"];
    [fileparams setObject:model.exerciseId forKey:@"exerciseId"];
    [fileparams setObject:model.id forKey:@"contentId"];
    [fileparams setObject:self.uniqueId forKey:@"uniqueLabel"];
    //file data
    NSString *path = [SBFileTool absolutePath:@"practice_audio_file" filePathType:SBFileToolPathTypeCache];
    NSString *filePath = [path stringByAppendingPathComponent:@"audio.aac"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    //5.上传录音文件
    MJWeakSelf;
    [MBProgressHUD showHUD];
    [SBAIPracticeRequest sb_uploadFileRequest:fileData params:fileparams Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        [MBProgressHUD hideHUD];
        if (isSuccess){
            [weakSelf setupQuestionRequestParams];
        }else{
            NSLog(@"上传录音文件失败Error:%@",responseObject.msg);
            tf_toastMsg(responseObject.msg);
        }
    }];
}

-(void)setupQuestionRequestParams{
    //0.涉及到异步，开始loading
    [MBProgressHUD showHUD];
    
    SBAIPracticeQuestionModel *model = self.dataModel.questionList[self.questionIndex];
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];
    //1.构建参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:model.id forKey:@"questionId"];//所答题目id(必填)
    [params setObject:loginModel.userId forKey:@"userId"];//用户id(必填)
    [params setObject:self.uniqueId forKey:@"uniqueLabel"];//唯一标识
    [params setObject:self.textView.text forKey:@"content"];//答题内容(必填)
    [params setObject:@(self.stageType) forKey:@"stageType"];//通关方式：0-培训；1-考核(最后一次提交必传)
    
    //2.音量计算
    CGFloat sum = 0;
    for (NSNumber *num in self.volumeArray) {
        sum = sum + num.floatValue;
    }
    //3.音量异常处理
    if (self.volumeArray.count) {
        CGFloat volume = sum/self.volumeArray.count ;
        [params setObject:@((int)volume) forKey:@"volume"];//声音大小(最后一题提交必填)
    }else{
        [params setObject:@(0) forKey:@"volume"];//声音大小(最后一题提交必填)
    }
    //4.最后一题参数额外构建
    if (self.questionIndex == self.dataModel.questionList.count - 1) {//最后一题
        //时间计算
        NSTimeInterval startTime = [self.startDate timeIntervalSince1970];
        //获取当前时间戳
        NSDate *currentDate = [NSDate date];
        NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
        //获取时间差
        NSTimeInterval cha = currentTime - startTime;
        //5.答题总用时
        [params setObject:@((int)cha*1000) forKey:@"timeSpend"];//用时（秒）(最后一题提交必填)
        //6.判断是否需要构建人脸参数
        if (self.dataModel.supervision){
            MJWeakSelf;
            //7.获取人脸表情识别信息
            [self.faceocrvc getExpressionMap:^(NSDictionary *resultDict) {
                [params setObject:resultDict forKey:@"expressionMap"];//用时（秒）(最后一题提交必填)
                [weakSelf commitQuestionRequest:params];
                return;
            }];
        }else{
            [self commitQuestionRequest:params];
        }
    }else{
        [self commitQuestionRequest:params];
    }
}

-(void)commitQuestionRequest:(NSMutableDictionary *)params{
    MJWeakSelf;
    [SBAIPracticeRequest sb_exerciseEvaluationScoreRequest:params Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        [MBProgressHUD hideHUD];
        if (isSuccess) {
            //1.最后一题,需要页面跳转到答题分析页面
            if (self.questionIndex == self.dataModel.questionList.count - 1) {//最后一题
                NSString *Id = [NSString stringWithFormat:@"%@",[responseObject.data objectForKey:@"id"]];
                [weakSelf pushPracticeAnalyseViewController:Id];
            }else{
                //2.设置功能按钮隐藏。
                weakSelf.commitButton.hidden = YES;
                weakSelf.resetButton.hidden = YES;
                weakSelf.recordButton.hidden = YES;
                //3.切换 肯定与否定 视频
                NSString *filename = [NSString stringWithFormat:@"%@.mp4",[SBAITool SB_MD5:weakSelf.dataModel.passVideo]];//url md5为参数
                NSString *path = [SBFileTool fileItemInCacheDirectory:filename];
                
                AVPlayerLayer *layer = [weakSelf setupPlayerLayerWithVideoPath:path];
                layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                
                [weakSelf.view.layer insertSublayer:layer above:self.avlayer];
                weakSelf.avlayer = layer;
                [weakSelf.player play];
                
                //4.设置当前播放状态
                weakSelf.playType = SBAIPracticePlayTypePass;
                //5.设置问答下标
                weakSelf.questionIndex++;
            }
            
            //6.获取分数结果
            NSString *scoreTotal = [NSString stringWithFormat:@"%@",[responseObject.data objectForKey:@"scoreTotal"]];
            weakSelf.scoreTotalLabel.text = [NSString stringWithFormat:@"%.2f",scoreTotal.floatValue];
            //7.开启分数动画
            [weakSelf startScoreAnimation];
        }else{
            NSLog(@"提交答题结果失败Error:%@",responseObject.msg);
            tf_toastMsg(responseObject.msg);
        }
    }];
}


-(void)pushPracticeAnalyseViewController:(NSString *)Id{
    [MBProgressHUD showHUD];
    //跳转答题分析页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        SBAIPracticeAnalyseViewController *vc = [[SBAIPracticeAnalyseViewController alloc] init];
        vc.Id = Id;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

#pragma mark ---------开启分数动画
-(void)startScoreAnimation{
    //1.分数显示
    self.scoreTotalLabel.hidden = NO;
    //2.开启分数结果动画
    [UIView animateWithDuration:1 animations:^{
        self.scoreTotalLabel.frame = CGRectMake((SCREEN_WIDTH - 100)/2.0, SCREEN_HEIGHT, 100, 50);
        self.scoreTotalLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.scoreTotalLabel.hidden = YES;
        self.scoreTotalLabel.alpha = 1;
        self.scoreTotalLabel.frame = CGRectMake((SCREEN_WIDTH - 100)/2.0, SCREEN_HEIGHT/2.0 - 25, 100, 50);
    }];
}

#pragma mark ---------人脸识别
-(void)openFaceTime{
    //1.GCD开启人脸识别倒计时
    MJWeakSelf;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),5.0*NSEC_PER_SEC, 0); //每5秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //2.获取人脸图片并注入
            [weakSelf getFaceImage];
        });
    });
    dispatch_resume(_timer);
}

-(void)stopFaceTime{
    //1.结束人脸识别倒计时
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
    //2.结束人脸识别会话
    [self.monitoringvc stopSession];
}

-(void)getFaceImage{
    //1.获取人脸图片
    UIImage *img = [self.monitoringvc getFaceImage];
    //2.注入人脸图片
    [self.faceocrvc faceImage:img];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return self.recordTextArray.count;
}

-(void)textViewDidChange:(UITextView *)textView{
    //编辑后重新记录录入内容
    [self.recordTextArray removeAllObjects];
    [self.recordTextArray addObject:textView.text];
}

-(void)backButtonEvent{
    [self backController];
}

#pragma mark ----------懒加载
-(SBAIPracticeTextView *)textView{
    if (!_textView) {
        _textView = [[SBAIPracticeTextView alloc] init];
        _textView.backgroundColor = HEXCOLORA(0x000000, 0.5);
        _textView.textColor = HEXCOLORA(0xffffff, 1);
        _textView.layer.cornerRadius = 8;
        _textView.font = FONT_SYS_NOR(18);
        _textView.clipsToBounds = YES;
        _textView.delegate = self;
    }
    return _textView;
}

-(UIButton *)resetButton{
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_reset"] forState:UIControlStateNormal];
        _resetButton.layer.cornerRadius = 23;
        _resetButton.clipsToBounds = YES;
        [_resetButton addTarget:self action:@selector(resetButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

-(UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_commit"] forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 23;
        _commitButton.clipsToBounds = YES;
        [_commitButton addTarget:self action:@selector(commitButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

-(UIButton *)recordButton{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_record"] forState:UIControlStateNormal];
        _recordButton.layer.cornerRadius = 32;
        _recordButton.clipsToBounds = YES;
        [_recordButton addTarget:self action:@selector(recordButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

- (AVAudioEngine *)audioEngine{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}

- (SFSpeechRecognizer *)speechRecognizer{
    if (!_speechRecognizer) {
        _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}

-(SFSpeechAudioBufferRecognitionRequest *)recognitionRequest{
    if (!_recognitionRequest) {
        _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        // 实时返回
        _recognitionRequest.shouldReportPartialResults = YES;
    }
    return _recognitionRequest;
}

-(SBAIMonitoringViewController *)monitoringvc{
    if(!_monitoringvc){
        _monitoringvc = [[SBAIMonitoringViewController alloc] init];
        _monitoringvc.isHidenNavigationBar = YES;
        [self addChildViewController:_monitoringvc];
    }
    return _monitoringvc;
}

-(SBAIFaceOcrViewController *)faceocrvc{
    if (!_faceocrvc) {
        _faceocrvc = [[SBAIFaceOcrViewController alloc] init];
        _faceocrvc.isHidenNavigationBar = YES;
        [self addChildViewController:_faceocrvc];
    }
    return _faceocrvc;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(SBAIPracticeAlertView *)alertView{
    if (!_alertView){
        _alertView = [[SBAIPracticeAlertView alloc] init];
    }
    return _alertView;
}

-(NSMutableArray *)volumeArray{
    if (!_volumeArray) {
        _volumeArray = [[NSMutableArray alloc] init];
    }
    return _volumeArray;
}

-(NSMutableArray *)recordTextArray{
    if (!_recordTextArray) {
        _recordTextArray = [[NSMutableArray alloc] init];
    }
    return _recordTextArray;
}

-(UILabel *)scoreTotalLabel{
    if (!_scoreTotalLabel){
        _scoreTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2.0, SCREEN_HEIGHT/2.0 - 25, 100, 50)];
        _scoreTotalLabel.backgroundColor = [UIColor greenColor];
        _scoreTotalLabel.textAlignment = NSTextAlignmentCenter;
        _scoreTotalLabel.textColor = [UIColor redColor];
        _scoreTotalLabel.font = FONT_SYS_MEDIUM(30);
        _scoreTotalLabel.layer.cornerRadius = 8;
        _scoreTotalLabel.clipsToBounds = YES;
        _scoreTotalLabel.hidden = YES;
    }
    return _scoreTotalLabel;
}

-(void)dealloc{
    [self stopallsession];
}
@end
