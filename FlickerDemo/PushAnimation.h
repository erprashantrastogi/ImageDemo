//
//  PopAnimator.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 07/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PushAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property CGFloat duration ;
@property BOOL presenting;
@property CGRect originFrame ;

@end
