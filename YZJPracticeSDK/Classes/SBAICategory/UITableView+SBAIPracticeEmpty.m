//
//  UITableView+SBAIPracticeEmpty.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/29.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "UITableView+SBAIPracticeEmpty.h"
#import "SBAIPracticeMainViewController.h"
#import "UIImage+SBAIBundle.h"

@implementation UITableView (SBAIPracticeEmpty)

-(void)emptyViewWithCount:(NSInteger)count imageName:(NSString*)imageName title:(NSString*)title{
    if (count) {
        self.backgroundView = nil;
    }else{
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        UIImage* image = [UIImage sb_imageNamedFromMyBundle:imageName];
        
        UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
        noMessageView.backgroundColor = [UIColor clearColor];
        
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 128, 85, 85)];
        [carImageView setImage:image];
        [noMessageView addSubview:carImageView];
        
        UILabel *noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carImageView.frame)+10, frame.size.width, 20)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.textColor = [UIColor lightGrayColor];
        noInfoLabel.text = title;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:16];
        [noMessageView addSubview:noInfoLabel];
        
        self.backgroundView = noMessageView;
    }
    
}

@end
