//
//  SBAILoginRequest.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/12.
//

#import <Foundation/Foundation.h>
#import "SBAIRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAILoginRequest : NSObject
///静默登录注册
+(void)sb_loginRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;
@end

NS_ASSUME_NONNULL_END
