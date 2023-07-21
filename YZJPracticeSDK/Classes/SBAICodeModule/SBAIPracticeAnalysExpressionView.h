//
//  SBAIPracticeAnalysExpressionView.h
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAIPracticeAnalyzeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeAnalysExpressionView : UIView
@property (nonatomic,strong) SBAIPracticeAnalyzeModel *model;

//是否结束动画
@property (nonatomic,assign) BOOL isfinish;

-(void)startAnimation;

@end

NS_ASSUME_NONNULL_END
