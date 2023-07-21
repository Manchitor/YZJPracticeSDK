//
//  SBAIPracticeLoginModel.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeLoginModel : NSObject

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,assign) int faceFlag;

@end

NS_ASSUME_NONNULL_END
