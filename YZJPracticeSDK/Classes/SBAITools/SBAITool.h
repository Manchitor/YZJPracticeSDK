//
//  SBAITool.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAITool : NSObject
/**
    判读是否为空或输入只有空格
 */
BOOL tf_isEmptyString(NSString *string);

/**
    判读对象是否为空
 */
BOOL tf_isEmptyObject(id data);

/**
    弹出信息
 */
void tf_toastMsg(NSString *msg);

///将秒转化为时分秒
+ (NSString *)timeFormat:(NSInteger)totalTime;
@end

NS_ASSUME_NONNULL_END
