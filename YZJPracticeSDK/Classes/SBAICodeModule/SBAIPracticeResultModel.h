//
//  SBAIPracticeResultModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeResultModel : NSObject

@property (nonatomic,copy) NSString *answer;

@property (nonatomic,copy) NSString *question;

@property (nonatomic,copy) NSString *answerAudio;

@property (nonatomic,copy) NSString *contentId;

@property (nonatomic,copy) NSString *createdDate;

@property (nonatomic,copy) NSString *empId;

@property (nonatomic,assign) long excecisesStaffId;

@property (nonatomic,copy) NSString *exerciseId;

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *keywords;

@property (nonatomic,assign) int scoreCater;//语言亲和

@property (nonatomic,copy) NSString *scoreCaterLevel;//语言亲和得分级别

@property (nonatomic,assign) int scoreCoherence;//语言连贯

@property (nonatomic,copy) NSString *scoreCoherenceLevel;//话语连贯得分级别

@property (nonatomic,assign) int scoreComplete;//内容完整

@property (nonatomic,copy) NSString *scoreCompleteLevel;//内容完整得分级别

@property (nonatomic,assign) int scoreCorrect;//表述准确

@property (nonatomic,copy) NSString *scoreCorrectLevel;//表述准确得分级别

@property (nonatomic,assign) int scoreHitrate;//关键词命中率

@property (nonatomic,assign) int scoreLogic;//语言逻辑

@property (nonatomic,copy) NSString *scoreLogicLevel;//语言逻辑得分级别

@property (nonatomic,assign) int scorePolite;//礼貌用语

@property (nonatomic,copy) NSString *scorePoliteLevel;//礼貌用语得分级别

@property (nonatomic,assign) int scorePositive;//积极态度

@property (nonatomic,copy) NSString *scorePositiveLevel;//积极态度得分级别

@property (nonatomic,assign) CGFloat scoreTotal;//综合得分

@property (nonatomic,copy) NSString *standardContent;

@property (nonatomic,copy) NSString *uniqueLabel;

@property (nonatomic,copy) NSString *updatedDate;

@property (nonatomic,copy) NSString *scoreLevel;//答题级别

@end

NS_ASSUME_NONNULL_END
