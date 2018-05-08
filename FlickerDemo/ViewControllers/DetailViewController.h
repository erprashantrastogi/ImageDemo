//
//  DetailViewController.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 07/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickerDataModel;

@interface DetailViewController : UIViewController

@property (nonatomic,strong) UIImage *thumbnailImage;
@property (nonatomic,strong) FlickerDataModel *flickerDataModel;
@end
