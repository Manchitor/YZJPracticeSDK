//
//  SBAIPracticeAnslyseReviewView.h
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAIPracticeAnalyzeModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^SBAIPracticeAnswerReviewItemBlock)(SBAIPracticeResultModel *item);

@interface SBAIPracticeAnslyseReviewView : UIView

@property (nonatomic,strong) SBAIPracticeAnalyzeModel *model;

@property (nonatomic,copy) SBAIPracticeAnswerReviewItemBlock _Nullable itemBlock;

@end

NS_ASSUME_NONNULL_END
