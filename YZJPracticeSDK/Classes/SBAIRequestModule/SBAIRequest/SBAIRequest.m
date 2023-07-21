//
//  SBAIRequest.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/4/10.
//

#import "SBAIRequest.h"
#import "SBAIApi.h"

@implementation SBAIRequest

///人脸注册
+(void)sb_face_registerRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    
    [RequestManager PostWithUrl:SB_API_FACE_REGISTER parameters:params response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}

@end
