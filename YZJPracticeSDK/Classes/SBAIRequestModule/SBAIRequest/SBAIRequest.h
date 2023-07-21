//
//  SBAIRequest.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "SBAIRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAIRequest : NSObject

///人脸注册
+(void)sb_face_registerRequest:(NSMutableDictionary*)params Success:(SBAIRequestResponseBlock) responseBlock;
@end

NS_ASSUME_NONNULL_END
