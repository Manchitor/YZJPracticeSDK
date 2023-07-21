//
//  SBAIPracticeQuestionModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeQuestionModel : NSObject
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *backgroundImage;
@property (nonatomic,copy) NSString *exerciseId;
@property (nonatomic,copy) NSString *exerciseName;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *question;

@end

NS_ASSUME_NONNULL_END

