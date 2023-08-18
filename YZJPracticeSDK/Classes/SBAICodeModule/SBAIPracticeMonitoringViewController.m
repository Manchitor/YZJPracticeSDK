//
//  SBAIPracticeMonitoringViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/8.
//

#import "SBAIPracticeMonitoringViewController.h"

#import "SBAIPractice.h"

@interface SBAIPracticeMonitoringViewController ()
@property (nonatomic,strong) UIImage *faceImg;

@property (nonatomic,copy) FaceImageBlock faceImageFinish;

@end

@implementation SBAIPracticeMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //收到faceImg
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceImageNotification:) name:@"SBAI_FACE_NOTIFICATION_RESULT" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBAI_FACE_NOTIFICATION_INIT" object:nil];
}

#pragma mark ----------获取faceimage
-(void)getFaceImage:(FaceImageBlock)finish{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBAI_FACE_NOTIFICATION_GET" object:nil];
    self.faceImageFinish = finish;
}

#pragma mark ----------收到faceimage
-(void)faceImageNotification:(NSNotification *)notification{
    UIImage *faceImg = [notification object];
    NSLog(@"SBAI_FACE_NOTIFICATION_RESULT");
    if (self.faceImageFinish) {
        self.faceImageFinish(faceImg ? faceImg : nil);
    }
}

#pragma mark ----------停止face
-(void)stopSession{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBAI_FACE_NOTIFICATION_STOP" object:nil];
    NSLog(@"SBAI_FACE_NOTIFICATION_STOP");
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
