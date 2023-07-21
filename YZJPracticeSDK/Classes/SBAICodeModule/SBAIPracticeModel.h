//
//  SBAIPracticeModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/4.
//

#import <Foundation/Foundation.h>
#import "SBAIPracticeQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeModel : NSObject

@property (nonatomic,copy) NSString *commonVideo;

@property (nonatomic,copy) NSString *coverImage;

@property (nonatomic,copy) NSString *createdDate;

@property (nonatomic,assign) long examineNumber;//考核次数

@property (nonatomic,copy) NSString *exerciseId;

@property (nonatomic,copy) NSString *exerciseName;

@property (nonatomic,assign) long exerciseStaffCount;//已训练次数

@property (nonatomic,assign) long examineStaffCount;//已考核次数

@property (nonatomic,assign) BOOL facialExpression;

@property (nonatomic,copy) NSString *offShelfDate;

@property (nonatomic,assign) long passMark;

@property (nonatomic,copy) NSString *passVideo;

@property (nonatomic,copy) NSString *robotCareer;

@property (nonatomic,copy) NSString *robotId;

@property (nonatomic,copy) NSString *robotName;

@property (nonatomic,assign) long robotType;

@property (nonatomic,assign) BOOL screenCutting;

@property (nonatomic,assign) BOOL screenshot;

@property (nonatomic,copy) NSString *speakVideo;

@property (nonatomic,assign) BOOL speechMatching;

@property (nonatomic,assign) long stageType;

@property (nonatomic,assign) long status;// 0-下架，1-上架，2-上架中，3-上架失败

@property (nonatomic,assign) BOOL supervision;

@property (nonatomic,assign) long trainingNumber;//需要训练次数

@property (nonatomic,copy) NSString *unPassVideo;

@property (nonatomic,copy) NSString *updatedDate;

@property (nonatomic,copy) NSString *waitVideo;

@property (nonatomic,copy) NSString *headerImg;//机器人图像

@property (nonatomic,assign) long hsRecordScore;


@property (nonatomic,strong) NSArray <SBAIPracticeQuestionModel *> *questionList;//问题列表


@end

NS_ASSUME_NONNULL_END
