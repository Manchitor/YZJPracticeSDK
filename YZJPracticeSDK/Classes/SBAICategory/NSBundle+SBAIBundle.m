//
//  NSBundle+SBAIBundle.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/28.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "NSBundle+SBAIBundle.h"
#import "SBAIPracticeMainViewController.h"

@implementation NSBundle (SBAIBundle)
static NSBundle * _myBundle;

+ (NSBundle *) myBundle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSBundle *bundle = [NSBundle bundleForClass:[SBAIPracticeMainViewController class]];
        
        NSURL *url = [bundle URLForResource:@"YZJPractice" withExtension:@"bundle"];
        
        NSBundle *resourceBundle = [NSBundle bundleWithURL:url];
        
        NSAssert(resourceBundle, @"bundle not found", nil);
        
        _myBundle = resourceBundle;
        
    });

    return _myBundle;
}

@end
