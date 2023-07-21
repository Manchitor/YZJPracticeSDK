//
//  SBAIPracticeListCell.h
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/29.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAIPracticeModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SBAIPracticeBlock)(SBAIPracticeModel *item);

@interface SBAIPracticeListCell : UITableViewCell

@property (nonatomic,strong) SBAIPracticeModel *model;
@property (nonatomic,copy) SBAIPracticeBlock _Nullable practiceBlock;

@end

NS_ASSUME_NONNULL_END
