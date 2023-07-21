//
//  SBAIResponseModel.m
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#import "SBAIResponseModel.h"

@implementation SBAIResponseModel
+ (NSDictionary *) mj_replacedKeyFromPropertyName {
    return @{
        @"entity":@[@"Entity", @"entity",@"result"],
        @"msg":@[@"",@"message",@"Message", @"Msg"],
        @"code":@[@"Code", @"code"],
    };
}

@end
