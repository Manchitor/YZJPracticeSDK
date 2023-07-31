//
//  SBAIMonitoringViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/8.
//

#import "SBAIMonitoringViewController.h"

#import "BDFaceVideoCaptureDevice.h"
#import "FaceParameterConfig.h"

#import "SBAIPractice.h"

#import <BDFaceBaseKit/BDFaceBaseKit.h>
//#import <IDLFaceSDK/IDLFaceSDK.h>

@interface SBAIMonitoringViewController ()
//<CaptureDataOutputProtocol,UIGestureRecognizerDelegate>

//@property (nonatomic, retain) BDFaceVideoCaptureDevice *videoCapture;
//
//@property (nonatomic, retain) UILabel * remindDetailLabel;
//
//
//@property (nonatomic, assign) BOOL hasFinished;
///**
// *  视频i流回显view
// */
//@property (nonatomic, retain) UIImageView *displayImageView;
//
///**
// * 人脸检测view，与视频流rect 一致
// */
//@property (nonatomic, assign) CGRect previewRect;
//
///**
// *  人脸预览view ，最大预览框之内，最小预览框之外，根据该view 提示离远离近
// */
//@property (nonatomic, assign) CGRect detectRect;

@end

@implementation SBAIMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    [self setupui];
//    [self initBaiduFace];
    
}
/**
#pragma mark ----------初始化百度人脸识别
-(void)initBaiduFace{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSURL *url = [bundle URLForResource:@"YZJPractice" withExtension:@"bundle"];
    
    NSBundle *resourceBundle = [NSBundle bundleWithURL:url];
    
    NSString *path = [resourceBundle pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    
    
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:path andRemoteAuthorize:false];
    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
    NSLog(@"version = %@",[[FaceSDKManager sharedInstance] getVersion]);
    
    [self initSDK];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
    self.videoCapture.runningStatus = NO;
#if TARGET_OS_SIMULATOR
#else
    [IDLFaceLivenessManager.sharedInstance reset];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasFinished = NO;
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
    self.videoCapture.delegate = self;
    self.videoCapture.position = AVCaptureDevicePositionFront; //AVCaptureDevicePositionBack;
#if TARGET_OS_SIMULATOR
#else
    [[IDLFaceLivenessManager sharedInstance] startInitial];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark ---------- 程序回到前台后台通知处理

- (void)onAppWillResignAction {
    _hasFinished = YES;
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
}

- (void)setupui{
    CGRect rect = CGRectMake(0, 0, 80, 100);
    // 用于播放视频流
    self.previewRect = rect;
    
    // 用于展示视频流的imageview
    self.displayImageView = [[UIImageView alloc] initWithFrame:self.previewRect];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.clipsToBounds = YES;
    [self.view addSubview:self.displayImageView];
    
    // 画圈和圆形遮罩
    self.detectRect = rect;
    
    // 提示label（遮挡等问题）
    self.remindDetailLabel = [[UILabel alloc] init];
    self.remindDetailLabel.frame = CGRectMake(0, rect.size.height - 20, rect.size.width, 20);
    self.remindDetailLabel.font = [UIFont systemFontOfSize:12];
    self.remindDetailLabel.textColor = [UIColor colorWithRed:246/255.0 green:166/255.0 blue:35/255.0 alpha:1];
    self.remindDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.remindDetailLabel.text = @"";
    self.remindDetailLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:self.remindDetailLabel];
    //    [self.remindDetailLabel setHidden:true];
    
    
    
    // 初始化相机处理类
    self.videoCapture = [[BDFaceVideoCaptureDevice alloc] init];
    self.videoCapture.delegate = self;
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
#pragma mark --------- CaptureDataOutputProtocol
- (void)captureOutputSampleBuffer:(UIImage *)image {
    if (_hasFinished) {
        return;
    }
    [self faceProcesss:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.displayImageView.image = image;
    });
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark -----------FACE SDK 初始化
- (void)initSDK {
    
    
    if (![[FaceSDKManager sharedInstance] canWork]){
        NSLog(@"授权失败，请检测ID 和 授权文件是否可用");
        return;
    }
    // 初始化SDK配置参数，可使用默认配置
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:200];
    // 设置截取人脸图片高
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:-1];
    // 设置截取人脸图片宽
    [[FaceSDKManager sharedInstance] setCropFaceSizeHeight:-1];
    // 设置人脸遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:0.7];
    // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setMinIllumThreshold:40];
    [[FaceSDKManager sharedInstance] setMaxIllumThreshold:240];
    // 设置图像模糊阀值
    [[FaceSDKManager sharedInstance] setBlurThreshold:0.3];
    // 设置头部姿态角度
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:10 yaw:10 roll:10];
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
    // 设置抠图的缩放倍数
    [[FaceSDKManager sharedInstance] setCropEnlargeRatio:2.2];
    // 设置照片采集张数
    [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
    // 设置超时时间
    [[FaceSDKManager sharedInstance] setConditionTimeout:15];
    // 设置原始图缩放比例
    [[FaceSDKManager sharedInstance] setImageWithScale:1];
    // 设置图片加密类型，type=0 基于base64 加密；type=1 基于百度安全算法加密
    [[FaceSDKManager sharedInstance] setImageEncrypteType:0];
    // 设置人脸过远框比例 liuyongji_______原：0.4 现改：1
    [[FaceSDKManager sharedInstance] setMinRect:1];
    // 初始化SDK功能函数
    [[FaceSDKManager sharedInstance] initCollect];
    
    /// 设置用户设置的配置参数
    //[BDFaceAdjustParamsTool setDefaultConfig];
    
    // 活体声音
    [IDLFaceLivenessManager sharedInstance].enableSound  = NO;
    // 图像采集声音
    [IDLFaceDetectionManager sharedInstance].enableSound = NO;
    
}
- (void)destorySDK{
    // 销毁SDK功能函数
    [[FaceSDKManager sharedInstance] uninitCollect];
}

- (void)faceProcesss:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [[IDLFaceDetectionManager sharedInstance] detectStratrgyWithNormalImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(FaceInfo *faceinfo, NSDictionary *images, DetectRemindCode remindCode) {
        switch (remindCode) {
            case DetectRemindCodeOK: {
                [weakSelf selfReplayFunction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.remindDetailLabel.text = @"监测中";
                    weakSelf.remindDetailLabel.textColor = UIColor.whiteColor;
                    weakSelf.displayImageView.layer.borderColor = HEXCOLOR(0x52A0FF).CGColor;
                    weakSelf.displayImageView.layer.borderWidth = 1;
                });
                
                
                break;
            }
            case DetectRemindCodeNoFaceDetected:{
                NSLog(@"DetectRemindCodeNoFaceDetected---把脸移入框内");
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.remindDetailLabel.text = @"未监测到人脸";
                    weakSelf.remindDetailLabel.textColor = UIColor.redColor;
                    weakSelf.displayImageView.layer.borderColor = [UIColor redColor].CGColor;
                    weakSelf.displayImageView.layer.borderWidth = 1;
                });
                
                break;;
            }
            case DetectRemindCodeBeyondPreviewFrame:{
                
            }
                break;
            case DetectRemindCodeVerifyInitError:
                NSLog(@"DetectRemindCodeVerifyInitError---验证失败");
                break;
            case DetectRemindCodeTimeout: {
                // 时间超时，重置之前采集数据
                [[IDLFaceDetectionManager sharedInstance] reset];
                NSLog(@"DetectRemindCodeTimeout---超时");
                break;
            }
            case DetectRemindCodeConditionMeet: {
            }
                break;
            default:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.remindDetailLabel.text = @"监测中";
                    weakSelf.remindDetailLabel.textColor = UIColor.whiteColor;
                    weakSelf.displayImageView.layer.borderColor = HEXCOLOR(0x52A0FF).CGColor;
                    weakSelf.displayImageView.layer.borderWidth = 1;
                });
            }
                break;
        }
    }];
}

- (void)selfReplayFunction{
    [[IDLFaceLivenessManager sharedInstance] reset];
}

-(UIImage *)getFaceImage{
    
    return [self makeImageWithView:self.displayImageView withSize:CGSizeMake(80, 100)];
}
-(void)stopSession{
    self.hasFinished = YES;
    self.videoCapture.runningStatus = NO;
#if TARGET_OS_SIMULATOR
#else
    [IDLFaceLivenessManager.sharedInstance reset];
#endif
}

//生成图片
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.videoCapture stopSession];
        self.videoCapture.delegate = nil;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
 */
@end
