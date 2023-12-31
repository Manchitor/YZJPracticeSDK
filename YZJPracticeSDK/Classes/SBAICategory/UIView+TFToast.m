//
//  UIView+TFToast.m
//
//
//  Created by 刘永吉 on 2020/8/19.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "UIView+TFToast.h"
#import <objc/runtime.h>
#import "ERFameDefine.h"

static const CGFloat TFToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat TFToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat TFToastHorizontalPadding   = 15.0;
static const CGFloat TFToastVerticalPadding     = 10.0;
static const CGFloat TFToastCornerRadius        = 10.0;
static const CGFloat TFToastOpacity             = 0.8;
static const CGFloat TFToastFontSize            = 16.0;
static const CGFloat TFToastMaxTitleLines       = 0;
static const CGFloat TFToastMaxMessageLines     = 0;
static const NSTimeInterval TFToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat TFToastShadowOpacity       = 0.8;
static const CGFloat TFToastShadowRadius        = 6.0;
static const CGSize  TFToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    TFToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval TFToastDefaultDuration  = 2.0;

// image view size
static const CGFloat TFToastImageViewWidth      = 80.0;
static const CGFloat TFToastImageViewHeight     = 80.0;

// activity
static const CGFloat TFToastActivityWidth       = 100.0;
static const CGFloat TFToastActivityHeight      = 100.0;
static const NSString * TFToastActivityDefaultPosition = @"center";

// interaction
static const BOOL TFToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * TFToastTimerKey         = @"TFToastTimerKey";
static const NSString * TFToastActivityViewKey  = @"TFToastActivityViewKey";
static const NSString * TFToastTapCallbackKey   = @"TFToastTapCallbackKey";

// positions
NSString * const TFToastPositionTop             = @"top";
NSString * const TFToastPositionCenter          = @"center";
NSString * const TFToastPositionBottom          = @"bottom";


@implementation UIView (TFToast)

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message
{
    [self makeToast:message
           duration:TFToastDefaultDuration
           position:nil];
}

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(id)position
{
    UIView *toast = [self viewForMessage:message
                                   title:nil
                                   image:nil];
    [self showToast:toast
           duration:duration
           position:position];
}

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(id)position
            title:(NSString *)title
{
    UIView *toast = [self viewForMessage:message
                                   title:title
                                   image:nil];
    [self showToast:toast
           duration:duration
           position:position];
}

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(id)position
            image:(UIImage *)image
{
    UIView *toast = [self viewForMessage:message
                                   title:nil
                                   image:image];
    [self showToast:toast
           duration:duration
           position:position];
}

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(id)position title:(NSString *)title
            image:(UIImage *)image
{
    UIView *toast = [self viewForMessage:message
                                   title:title
                                   image:image];
    [self showToast:toast
           duration:duration
           position:position];
}

- (void)showToast:(UIView *)toast
{
    [self showToast:toast
           duration:TFToastDefaultDuration
           position:nil];
}


- (void)showToast:(UIView *)toast
         duration:(NSTimeInterval)duration
         position:(id)position
{
    [self showToast:toast
           duration:duration
           position:position
        tapCallback:nil];
    
}


- (void)showToast:(UIView *)toast
         duration:(NSTimeInterval)duration
         position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    
    [self showToast:toast
           duration:duration
           position:position
    verticalPadding:TFToastVerticalPadding
        tapCallback:tapCallback];
}

- (void)showToast:(UIView *)toast
         duration:(NSTimeInterval)duration
         position:(id)position
  verticalPadding:(CGFloat)verticalPadding
      tapCallback:(void(^)(void))tapCallback {
    
    toast.center = [self centerPointForPosition:position withToast:toast verticalPadding:verticalPadding];
    toast.alpha  = 0.0;
    
    if (TFToastHidesOnTap && !tapCallback)
    {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:TFToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         
                         toast.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                                           target:self
                                                                         selector:@selector(toastTimerDidFinish:)
                                                                         userInfo:toast
                                                                          repeats:NO];
                         // associate the timer with the toast view
                         
                         objc_setAssociatedObject (toast, &TFToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         
                         objc_setAssociatedObject (toast, &TFToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)hideToastView:(UIView *)toast
{
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &TFToastTimerKey);
    [timer invalidate];
    
    [UIView animateWithDuration:TFToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         
                         toast.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)toastTimerDidFinish:(NSTimer *)timer
{
    [self hideToastView:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer
{
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &TFToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &TFToastTapCallbackKey);
    if (callback)
    {
        callback();
    }
    
    [self hideToastView:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)makeToastActivity
{
    [self makeToastActivity:TFToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position
{
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &TFToastActivityViewKey);
    
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFToastActivityWidth, TFToastActivityHeight)];
    
    activityView.center             = [self centerPointForPosition:position withToast:activityView verticalPadding:TFToastVerticalPadding];
    activityView.backgroundColor    = [[UIColor blackColor] colorWithAlphaComponent:TFToastOpacity];
    activityView.alpha              = 0.0;
    activityView.autoresizingMask   = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = TFToastCornerRadius;
    
    if (TFToastDisplayShadow)
    {
        activityView.layer.shadowColor   = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = TFToastShadowOpacity;
        activityView.layer.shadowRadius  = TFToastShadowRadius;
        activityView.layer.shadowOffset  = TFToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &TFToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:TFToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         activityView.alpha = 1.0;
                         
                     } completion:nil];
}

- (void)hideToastActivity
{
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &TFToastActivityViewKey);
    
    if (existingActivityView != nil)
    {
        [UIView animateWithDuration:TFToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             
                             existingActivityView.alpha = 0.0;
                             
                         } completion:^(BOOL finished) {
                             
                             [existingActivityView removeFromSuperview];
                             
                             objc_setAssociatedObject (self, &TFToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast verticalPadding:(CGFloat)verticalPadding
{
    if([point isKindOfClass:[NSString class]])
    {
        if([point caseInsensitiveCompare:TFToastPositionTop] == NSOrderedSame)
        {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + NAV_HEIGHT);
        }
        else if([point caseInsensitiveCompare:TFToastPositionCenter] == NSOrderedSame)
        {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    }
    else if ([point isKindOfClass:[NSValue class]])
    {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - verticalPadding);
}

- (CGSize)sizeForString:(NSString *)string
                   font:(UIFont *)font
      constrainedToSize:(CGSize)constrainedSize
          lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)viewForMessage:(NSString *)message
                     title:(NSString *)title
                     image:(UIImage *)image
{
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel  = nil;
    UILabel *titleLabel    = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    
    wrapperView.layer.cornerRadius = TFToastCornerRadius;
    
    if (TFToastDisplayShadow)
    {
        wrapperView.layer.shadowColor   = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = TFToastShadowOpacity;
        wrapperView.layer.shadowRadius  = TFToastShadowRadius;
        wrapperView.layer.shadowOffset  = TFToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TFToastOpacity];
    
    if(image != nil)
    {
        imageView             = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame       = CGRectMake(TFToastHorizontalPadding, TFToastVerticalPadding, TFToastImageViewWidth, TFToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil)
    {
        imageWidth  = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft   = TFToastHorizontalPadding;
    }
    else
    {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil)
    {
        titleLabel                 = [[UILabel alloc] init];
        titleLabel.numberOfLines   = TFToastMaxTitleLines;
        titleLabel.font            = [UIFont boldSystemFontOfSize:TFToastFontSize];
        titleLabel.textAlignment   = NSTextAlignmentLeft;
        titleLabel.lineBreakMode   = NSLineBreakByWordWrapping;
        titleLabel.textColor       = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha           = 1.0;
        titleLabel.text            = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle      = CGSizeMake((self.bounds.size.width * TFToastMaxWidth) - imageWidth, self.bounds.size.height * TFToastMaxHeight);
        CGSize expectedSizeTitle = [self sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame         = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil)
    {
        messageLabel                 = [[UILabel alloc] init];
        messageLabel.numberOfLines   = TFToastMaxMessageLines;
        messageLabel.font            = [UIFont systemFontOfSize:TFToastFontSize];
        messageLabel.lineBreakMode   = NSLineBreakByWordWrapping;
        messageLabel.textColor       = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha           = 1.0;
        messageLabel.text            = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage      = CGSizeMake((self.bounds.size.width * TFToastMaxWidth) - imageWidth, self.bounds.size.height * TFToastMaxHeight);
        
        CGSize expectedSizeMessage = [self sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        
        messageLabel.frame         = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil)
    {
        titleWidth  = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop    = TFToastVerticalPadding;
        titleLeft   = imageLeft + imageWidth + TFToastHorizontalPadding;
    }
    else
    {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil)
    {
        messageWidth  = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft   = imageLeft + imageWidth + TFToastHorizontalPadding;
        messageTop    = titleTop + titleHeight + TFToastVerticalPadding;
    }
    else
    {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft  = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (TFToastHorizontalPadding * 2)), (longerLeft + longerWidth + TFToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + TFToastVerticalPadding), (imageHeight + (TFToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil)
    {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil)
    {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil)
    {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end
