//
//  SBAIPracticeProgressView.h
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/7/5.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeProgressView : UIView
-(void)setLevel:(NSString *)level value:(int)value name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
