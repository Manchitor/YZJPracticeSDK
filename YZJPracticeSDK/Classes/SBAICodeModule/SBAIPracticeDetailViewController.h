//
//  SBAIPracticeDetailViewController.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/29.
//

#import "SBAIBaseViewController.h"
#import "SBAIPracticeModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 当前视频播放类型
typedef NS_ENUM(NSInteger, SBAIPracticePlayType) {
    /// 讲话
    SBAIPracticePlayTypeSpeak              = 0,
    /// 等待
    SBAIPracticePlayTypeWait               = 1,
    /// 通过
    SBAIPracticePlayTypePass               = 2,
    /// 未通过
    SBAIPracticePlayTypeUnpass             = 3
};

/// 当前视频播放类型
typedef NS_ENUM(NSInteger, SBAIPracticeStageType) {
    /// 训练
    SBAIPracticeStageTypeExercise           = 0,
    /// 考核
    SBAIPracticeStageTypeExamine            = 1
};

@interface SBAIPracticeDetailViewController : SBAIBaseViewController

@property (nonatomic,strong) SBAIPracticeModel *dataModel;
//训练/考核
@property (nonatomic,assign) SBAIPracticeStageType stageType;
@end

NS_ASSUME_NONNULL_END
