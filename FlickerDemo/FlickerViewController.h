//
//  ViewController.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 02/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushAnimation.h"

@interface FlickerViewController : UIViewController<UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) PushAnimation *transition;

@end

