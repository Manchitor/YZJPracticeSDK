//
//  SBAIResponseModel.h
//  ElectricRoom
//  封装请求的返回模型
//  Created by 刘永吉 on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIResponseModel : NSObject

@property (nonatomic) id data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
