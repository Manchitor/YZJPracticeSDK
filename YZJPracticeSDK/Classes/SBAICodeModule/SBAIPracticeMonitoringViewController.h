//
//  SBAIPracticeMonitoringViewController.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/8.
//

#import "SBAIBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^FaceImageBlock)(UIImage *faceImage);

@interface SBAIPracticeMonitoringViewController : SBAIBaseViewController


-(void)getFaceImage:(FaceImageBlock)finish;

-(void)stopSession;


@end

NS_ASSUME_NONNULL_END
