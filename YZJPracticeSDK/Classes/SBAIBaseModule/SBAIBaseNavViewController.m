//
//  SBAIBaseNavViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/4/12.
//

#import "SBAIBaseNavViewController.h"

#import "ERColorDefine.h"
#import "ERFontDefine.h"

@interface SBAIBaseNavViewController ()

@end

@implementation SBAIBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

-(void)setup{
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : COLOR_TEXT_DEFAULT,NSFontAttributeName:FONT_SYS_MEDIUM(18)};//ios13适配
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:NO];
    self.interactivePopGestureRecognizer.enabled = YES;
    
    
    if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            appearance.backgroundImage = [[UIImage alloc] init]; //图⽚
            appearance.backgroundColor = [UIColor whiteColor]; //背景⾊
        appearance.titleTextAttributes = @{NSFontAttributeName:FONT_SYS_MEDIUM(18),NSForegroundColorAttributeName : [UIColor whiteColor]};//ios13适配

            appearance.shadowColor = UIColor.clearColor; //阴影
            self.navigationBar.standardAppearance = appearance;
            self.navigationBar.scrollEdgeAppearance = appearance;
        }
}

@end
