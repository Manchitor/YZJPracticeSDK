//
//  SBAIPracticeTextView.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/23.
//

#import "SBAIPracticeTextView.h"

@implementation SBAIPracticeTextView

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
   UIMenuController *menuController = [UIMenuController sharedMenuController];
   if (menuController) {
        //直接隐藏菜单
       [UIMenuController sharedMenuController].menuVisible = NO;
   }
   return NO;
}

@end
