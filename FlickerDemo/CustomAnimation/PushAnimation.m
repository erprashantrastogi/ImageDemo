//
//  PopAnimator.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 07/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "PushAnimation.h"

@interface PushAnimation()

@end

@implementation PushAnimation

#pragma mark: UIViewControllerAnimatedTransitioning

- (id)init{
    self = [super init];
    if (self) {
        self.duration = 0.3;
        self.presenting = true;
        self.originFrame = CGRectZero;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *detailView = self.presenting ? toView : [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    
    CGRect initialFrame = self.presenting ? self.originFrame : detailView.frame;
    CGRect finalFrame = self.presenting ? detailView.frame : self.originFrame;
    
    CGFloat initialWidth = initialFrame.size.width;
    CGFloat initialHeight = initialFrame.size.height;
    
    CGFloat finalWidth = finalFrame.size.width;
    CGFloat finalHeight = finalFrame.size.height;
    
    CGFloat xScaleFactor = self.presenting ? (initialWidth / finalWidth) : finalWidth / initialWidth ;
    
    CGFloat yScaleFactor = self.presenting ? (initialHeight / finalHeight) : finalHeight / initialHeight;
    
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);
    
    
    
    if (self.presenting ){
        detailView.transform = scaleTransform;
        detailView.center = CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));
        detailView.clipsToBounds = true;
    }
    
    [containerView addSubview:toView];
    [containerView bringSubviewToFront:detailView];
    
    [UIView animateWithDuration:self.duration animations:^{
        
        detailView.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform;
        detailView.center = CGPointMake(CGRectGetMidX(finalFrame), CGRectGetMidY(finalFrame));
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:true];
    }];
}


@end
