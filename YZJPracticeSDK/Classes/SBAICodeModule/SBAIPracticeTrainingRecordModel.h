//
//  SBAIPracticeTrainingRecordModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeTrainingRecordModel : NSObject

@property (nonatomic,copy) NSString *exerciseName;

@property (nonatomic,copy) NSString *id;

@property (nonatomic,assign) CGFloat answerAnalyseScore;

@property (nonatomic,copy) NSString *exerciseDate;


@end

NS_ASSUME_NONNULL_END
