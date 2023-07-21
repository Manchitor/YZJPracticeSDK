//
//  SBAIBaseViewController.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBAIBaseViewController : UIViewController
///是否隐藏导航栏
@property (nonatomic,assign) BOOL isHidenNavigationBar;

///是否隐藏导航栏左边按钮
@property (nonatomic,assign) BOOL isHidenBackItem;

///导航栏颜色
@property (nonatomic,assign) BOOL clearColorNavigationBar;



///初始化默认导航栏左边按钮
-(void)initLeftImage:(NSString *)strImage selector:(SEL)selector;

///默认导航栏返回按钮点击事件
-(void)backController;

///修改导航栏颜色
-(void)setupNavigationBarColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
