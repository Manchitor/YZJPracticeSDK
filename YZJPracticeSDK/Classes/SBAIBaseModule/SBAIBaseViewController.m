//
//  SBAIBaseViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/4/12.
//

#import "SBAIBaseViewController.h"

#import "ERColorDefine.h"
#import "ERFontDefine.h"
#import "UIImage+SBAIBundle.h"

@interface SBAIBaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation SBAIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_VIEW_BG;
    if (!self.isHidenBackItem) {
        [self initLeftImage:@"sb_ai_nav_back" selector:@selector(backController)];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.isHidenNavigationBar animated:YES];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    if (self.clearColorNavigationBar) {
        [self setupNavigationBarColor:HEXCOLOR(0xF8F8F8)];
    }else{
        [self setupNavigationBarColor:[UIColor whiteColor]];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController setNavigationBarHidden:self.isHidenNavigationBar animated:YES];
}

#pragma mark ---------修改导航栏颜色
-(void)setupNavigationBarColor:(UIColor *)color{
    self.navigationController.navigationBar.barTintColor = color;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : COLOR_TEXT_DEFAULT,NSFontAttributeName:FONT_SYS_MEDIUM(16)};//ios13适配
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.delegate = self;
    
    if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            appearance.backgroundImage = [[UIImage alloc] init]; //图⽚
            appearance.backgroundColor = color; //背景⾊
        appearance.titleTextAttributes = @{NSFontAttributeName:FONT_SYS_MEDIUM(16),NSForegroundColorAttributeName : COLOR_TEXT_DEFAULT};//ios13适配

            appearance.shadowColor = UIColor.clearColor; //阴影
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

#pragma mark ---------初始化默认导航栏左边按钮
-(void)initLeftImage:(NSString *)strImage selector:(SEL)selector{
    CGRect rect = CGRectMake(0, 0, 44, 44);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_nav_back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage sb_imageNamedFromMyBundle:@"sb_ai_nav_back"] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark ---------默认导航栏返回按钮点击事件
-(void)backController{
    if (self.presentingViewController!=nil){
        if (self.navigationController==nil){
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        NSArray *arr = self.navigationController.viewControllers;
        if ([arr count]>0){
            if (self==self.navigationController.viewControllers[0]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        if (self.navigationController==nil){
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count<=1){//如果是跟控制器就不支持侧滑返回
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void) dealloc {
    
    NSLog(@"dealloc:%@",NSStringFromClass([self class]));
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
