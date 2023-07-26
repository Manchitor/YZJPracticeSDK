//
//  YZJViewController.m
//  YZJPracticeSDK
//
//  Created by Manchitor on 07/21/2023.
//  Copyright (c) 2023 Manchitor. All rights reserved.
//

#import "YZJViewController.h"
#import <YZJPracticeSDK/SBAIPracticeMainViewController.h>
#import <YZJPracticeSDK/SBAIBaseNavViewController.h>

@interface YZJViewController ()

@end

@implementation YZJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SBAIPracticeMainViewController *vc = [[SBAIPracticeMainViewController alloc] init];
    SBAIBaseNavViewController *nav = [[SBAIBaseNavViewController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
