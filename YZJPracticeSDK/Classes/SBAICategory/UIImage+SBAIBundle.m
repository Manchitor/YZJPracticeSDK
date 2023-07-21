//
//  UIImage+SBAIBundle.m
//  SBAIPractice
//
//  Created by 刘永吉 on 2023/6/29.
//

#import "UIImage+SBAIBundle.h"
#import "NSBundle+SBAIBundle.h"
@implementation UIImage (SBAIBundle)

+ (UIImage *)sb_imageNamedFromMyBundle:(NSString *)name {
    
    NSBundle *imageBundle = [NSBundle myBundle];
        
    UIImage *imagea = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
        
    return imagea;
}
@end
