//
//  FlickerCollectionViewCell.h
//  FlickerDemo
//
//  Created by Prashant Rastogi on 03/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickerDataModel;
@interface FlickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (void)updateViewWithDataModel:(FlickerDataModel *)flickerDataModel;
@end
