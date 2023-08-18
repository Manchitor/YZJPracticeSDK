//
//  SBAIFaceOcrViewController.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/11.
//

#import "SBAIBaseViewController.h"
#import "SBAIPractice.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBAIPracticeFaceOcrViewController : SBAIBaseViewController

-(void) faceImage:(UIImage *)faceImg;

-(void) getExpressionMap:(DictionaryBlock)block;

@end

NS_ASSUME_NONNULL_END
