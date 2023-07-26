//
//  SBAIPracticeTrainingRecordModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeTrainingRecordModel : NSObject

@property (nonatomic,copy) NSString *empid;//成员id

@property (nonatomic,copy) NSString *id;//考核(或训练)记录id

@property (nonatomic,assign) CGFloat answerAnalyseScore;//考核(或训练)总分

@property (nonatomic,copy) NSString *exerciseDate;//考核(或训练)时间

@property (nonatomic,copy) NSString *exerciseEndDate;//考核(或训练)结束时间

@property (nonatomic,assign) int stageType;//0 培训；1考核


@end

NS_ASSUME_NONNULL_END
