//
//  SBAILoginRequest.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import "SBAILoginRequest.h"
#import "SBAIApi.h"

@implementation SBAILoginRequest
///静默登录注册
+(void)sb_loginRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock{
    [RequestManager PostWithUrl:SB_API_PHONELOGIN parameters:params response:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        if (responseBlock) {
            responseBlock(isSuccess,responseObject);
        }
    }];
}
@end
