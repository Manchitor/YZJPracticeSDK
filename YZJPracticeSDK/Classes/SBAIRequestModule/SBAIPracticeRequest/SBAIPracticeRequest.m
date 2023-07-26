//
//  SBAIPracticeRequest.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import "SBAIPracticeRequest.h"
#import "SBAIAPI.h"

@implementation SBAIPracticeRequest
///用户对应陪练列表
+(void)sb_exerciseListRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager PostWithUrl:SB_API_EXERCISE_LIST parameters:params response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}

///培训记录
+(void)sb_exerciseTrainingRecoedRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager GetWithUrl:SB_API_TRAINING_RECORD_LIST parameters:params timeoutInterval:30 response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
    
}

///答题分析
+(void)sb_exerciseAnalyzeRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager PostWithUrl:SB_API_PRACTICE_ANALYZE parameters:params response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}

///答题打分
+(void)sb_exerciseEvaluationScoreRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager PostWithUrl:SB_API_PRACTICE_COMMENT parameters:params response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}

//语音上传
+(void)sb_uploadFileRequest:(NSData*)filelData params:(NSMutableDictionary *)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager PostFileWithUrl:SB_API_PRACTICE_UPLOAD_FILE timeoutInterval:30 fileData:filelData fileName:@"files.mp3" parameters:params response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}

///陪练详情
+(void)sb_exerciseDetailScoreRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager GetWithUrl:SB_API_EXERCISE_DETAIL parameters:params timeoutInterval:30 response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}
@end
