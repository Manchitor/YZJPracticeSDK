//
//  SBAIPracticeAnalyzeModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/13.
//

#import <Foundation/Foundation.h>
#import "SBAIPracticeResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeAnalyzeModel : NSObject

@property (nonatomic,copy) NSString *empId;

@property (nonatomic,copy) NSString *empName;

@property (nonatomic,copy) NSString *prompt;

@property (nonatomic,copy) NSString *exerciseDate;

@property (nonatomic,copy) NSString *exerciseEndDate;

@property (nonatomic,copy) NSString *exerciseId;

@property (nonatomic,copy) NSString *exerciseName;

@property (nonatomic,assign) int id;

@property (nonatomic,assign) int isPass;

@property (nonatomic,copy) NSString *orgId;

@property (nonatomic,copy) NSString *orgName;

@property (nonatomic,assign) int scoreAffine;

@property (nonatomic,assign) int scoreAngry;

@property (nonatomic,assign) int scoreAppeal;

@property (nonatomic,assign) int scoreAssurance;

@property (nonatomic,assign) int scoreCater;

@property (nonatomic,assign) int scoreCoherence;

@property (nonatomic,assign) int scoreComplete;

@property (nonatomic,assign) int scoreCorrect;

@property (nonatomic,assign) int scoreFlat;

@property (nonatomic,assign) int scoreGenerous;

@property (nonatomic,assign) int scoreHitrate;

@property (nonatomic,assign) int scoreIndifferent;

@property (nonatomic,assign) int scoreLogic;

@property (nonatomic,assign) int scoreNervous;

@property (nonatomic,assign) int scorePolite;

@property (nonatomic,assign) int scorePositive;

@property (nonatomic,assign) int scoreQuality;

@property (nonatomic,assign) int scoreServiceability;

@property (nonatomic,assign) CGFloat answerAnalyseScore;

@property (nonatomic,strong) NSArray<SBAIPracticeResultModel *> *staffEntities;

@property (nonatomic,assign) int stageType;

@property (nonatomic,assign) int timeSpend;

@property (nonatomic,assign) BOOL supervision;


@property (nonatomic,copy) NSString *uniqueLabel;

@end

NS_ASSUME_NONNULL_END
