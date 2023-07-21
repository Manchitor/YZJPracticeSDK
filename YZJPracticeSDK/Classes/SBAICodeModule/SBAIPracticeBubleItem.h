//
//  SBAIPracticeBubleItem.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeBubleItem : UIView
///横向
@property (nonatomic,assign) BOOL transverse;
///纵向
@property (nonatomic,assign) BOOL longitudinal;
//移动速度
@property (nonatomic,assign) CGFloat speed;

-(void)setupEmoji:(NSString *)emoji speed:(CGFloat)speed transverse:(BOOL)transverse longitudinal:(BOOL)longitudinal;

@end

NS_ASSUME_NONNULL_END
