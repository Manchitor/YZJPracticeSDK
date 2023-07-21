//
//  UITableView+SBAIPracticeEmpty.h
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/29.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (SBAIPracticeEmpty)
 
-(void)emptyViewWithCount:(NSInteger)count imageName:(NSString*)imageName title:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
