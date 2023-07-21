//
//  SBAITool.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2022/5/25.
//

#import "SBAITool.h"

#import "UIView+TFToast.h"

@implementation SBAITool
/**
 判读是否为空或输入只有空格
 */
BOOL tf_isEmptyString(NSString *string){
    if (!string || [string isEqual:[NSNull null]]){
        return YES;
    }else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0 || [trimedString isEqualToString:@"(null)"]){
            return YES;
        }else{
            return NO;
        }
    }
}

/**
 判读对象是否为空
 */
BOOL tf_isEmptyObject(id data){
    BOOL result = NO;
    if (data != nil) {
        if ([data isKindOfClass:[NSObject class]]) {
            if ([data isKindOfClass:[NSString class]]) {
                if ([(NSString *)data isEqualToString:@""] || data == nil) {
                    result = YES;
                }
            }
            else if ([data isKindOfClass:[NSArray class]]){
                if (((NSArray *)data).count == 0 || data == nil) {
                    result = YES;
                }
            }
            else if(data == nil)
            {
                result = YES;
            }
        }
    }else{
        result = YES;
    }
    
    return result;
}

/**
 弹框提示信息
 */
void tf_toastMsg(NSString *msg) {
    UIWindow *win = [[UIApplication sharedApplication].delegate window];
    if (msg.length){
        [win makeToast:msg];
    }
}

///将秒转化为时分秒
+ (NSString *)timeFormat:(NSInteger)totalTime {
    if (totalTime < 0) {
        return @"";
    }
    NSInteger durHour = totalTime / 3600;
    NSInteger durMin = (totalTime / 60) % 60;
    NSInteger durSec = totalTime % 60;
    
    if (durHour > 0) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", durHour, durMin, durSec];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}
@end
