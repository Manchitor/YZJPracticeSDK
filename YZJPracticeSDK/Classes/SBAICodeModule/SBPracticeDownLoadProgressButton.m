//
//  SBPracticeDownLoadProgressButton.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/6/14.
//

#import "SBPracticeDownLoadProgressButton.h"
#import "SBAIPractice.h"
@implementation SBPracticeDownLoadProgressButton


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath*path=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, (SCREEN_WIDTH - 130)*self.progress, 42) cornerRadius:0];

    path.lineWidth=20;

    //填充颜色

    UIColor*fillColor=[UIColor clearColor];

    [fillColor set];

    [path fill];

   
}

@end
