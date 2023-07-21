//
//  SBAIPracticeRequest.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import <Foundation/Foundation.h>
#import "SBAIRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeRequest : NSObject
///用户对应陪练列表
+(void)sb_exerciseListRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;

///培训记录
+(void)sb_exerciseTrainingRecoedRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;

///答题分析
+(void)sb_exerciseAnalyzeRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;

///答题打分
+(void)sb_exerciseEvaluationScoreRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;

//语音上传
+(void)sb_uploadFileRequest:(NSData*)filelData params:(NSMutableDictionary *)params Success:(SBAIRequestResponseBlock) responseBlock;

///陪练详情
+(void)sb_exerciseDetailScoreRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;
@end

NS_ASSUME_NONNULL_END
