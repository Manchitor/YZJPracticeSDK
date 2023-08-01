//
//  SBAIMonitoringViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/8.
//

#import "SBAIMonitoringViewController.h"

#import "SBAIPractice.h"

@interface SBAIMonitoringViewController ()

@end

@implementation SBAIMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    [self setupui];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceImage:) name:@"SBAI_FACE_NOTIFICATION_RESULT" object:nil];
}

-(void)faceImage:(NSNotification *)notification{
    NSString *string = [notification object];
    NSLog(@"SBAI_FACE_NOTIFICATION_RESULT:%@",string);
}

-(UIImage *)getFaceImage{
    return [[UIImage alloc] init];
}

-(void)stopSession{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SBAI_FACE_NOTIFICATION_STOP" object:nil];
    NSLog(@"SBAI_FACE_NOTIFICATION_STOP");
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
