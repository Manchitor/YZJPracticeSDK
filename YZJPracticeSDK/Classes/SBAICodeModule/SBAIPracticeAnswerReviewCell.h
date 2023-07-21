//
//  SBAIPracticeAnswerReviewCell.h
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/3.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAIPracticeResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeAnswerReviewCell : UITableViewCell

@property (nonatomic,strong) SBAIPracticeResultModel *model;

-(void)setModel:(SBAIPracticeResultModel * _Nonnull)model index:(NSInteger) index;
@end

NS_ASSUME_NONNULL_END
