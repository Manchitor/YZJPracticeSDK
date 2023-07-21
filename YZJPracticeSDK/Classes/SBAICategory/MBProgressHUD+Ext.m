//
//  MBProgressHUD+Ext.m
//
//
//  Created by 刘永吉 on 2020/8/19.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "MBProgressHUD+Ext.h"

@implementation MBProgressHUD (Ext)


+ (void) showHUD {
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
}


+ (void) hideHUD {
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
}
@end
