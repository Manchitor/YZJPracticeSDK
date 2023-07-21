//
//  ERBlockDefine.h
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#ifndef ERBlockDefine_h
#define ERBlockDefine_h
#import <Foundation/Foundation.h>

typedef void (^ErrorBlock)(NSError *error);
typedef void (^VoidBlock)(void);

typedef void (^NotificationBlock)(NSNotification *notification);

typedef void (^BoolBlock)(BOOL result);
typedef void (^BoolMsgBlock)(BOOL result, NSString *errorMsg);

typedef void (^ArrayBlock)(NSArray *resultList);
typedef void (^ArrayMsgBlock)(NSArray *resultList, NSString *errorMsg);

typedef void (^DictionaryBlock)(NSDictionary *resultDict);
typedef void (^DictionaryMsgBlock)(NSDictionary *resultDict, NSString *errorMsg);

typedef void (^NumberBlock)(NSNumber *resultNumber);
typedef void (^NumberMsgBlock)(NSNumber *resultNumber, NSString *errorMsg);

typedef void (^IntegerBlock)(NSInteger resultNumber);
typedef void (^IntegerMsgBlock)(NSInteger resultNumber, NSString *errorMsg);

typedef void (^StringBlock)(NSString *result);
typedef void (^StringMsgBlock)(NSString *result, NSString *errorMsg);

typedef void (^ObjectBlock)(id sender);
typedef void (^ObjectMsgBlock)(id result, NSString *errorMsg);

typedef void (^DoubleBlock)(double resultDouble);

#endif /* ERBlockDefine_h */
